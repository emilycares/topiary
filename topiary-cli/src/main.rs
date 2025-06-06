mod cli;
mod error;
mod fs;
mod io;
mod language;
mod visualisation;

use std::{
    error::Error,
    io::{BufReader, BufWriter},
    process::ExitCode,
};

use error::Benign;
use topiary_core::{coverage, formatter, Operation};

use crate::{
    cli::Commands,
    error::{CLIError, CLIResult, TopiaryError},
    io::{Inputs, OutputFile},
    language::LanguageDefinitionCache,
};

#[tokio::main]
async fn main() -> ExitCode {
    if let Err(e) = run().await {
        if !e.benign() {
            print_error(&e)
        }
        return e.into();
    }

    ExitCode::SUCCESS
}

async fn run() -> CLIResult<()> {
    let args = cli::get_args()?;

    let (config, nickel_config) = topiary_config::Configuration::fetch(
        args.global.merge_configuration,
        &args.global.configuration,
    )?;

    // Delegate by subcommand
    match args.command {
        Commands::Format {
            tolerate_parsing_errors,
            skip_idempotence,
            inputs,
        } => {
            let inputs = Inputs::new(&config, &inputs);
            let cache = LanguageDefinitionCache::new();

            let (_, mut results) = async_scoped::TokioScope::scope_and_block(|scope| {
                for input in inputs {
                    scope.spawn(async {
                        let result: CLIResult<()> = match input {
                            Ok(input) => {
                                let language = cache.fetch(&input).await?;
                                let output = OutputFile::try_from(&input)?;

                                log::info!(
                                    "Formatting {}, as {} using {}, to {}",
                                    input.source(),
                                    input.language().name,
                                    input.query(),
                                    output
                                );

                                let mut buf_output = BufWriter::new(output);

                                {
                                    // NOTE This newly opened scope is important! `buf_input` takes
                                    // ownership of `input`, which -- upon reading -- contains an
                                    // open file handle. We need to close this file, by dropping
                                    // `buf_input`, before we attempt to persist our output.
                                    // Otherwise, we get an exclusive lock problem on Windows.
                                    let mut buf_input = BufReader::new(input);

                                    formatter(
                                        &mut buf_input,
                                        &mut buf_output,
                                        &language,
                                        Operation::Format {
                                            skip_idempotence,
                                            tolerate_parsing_errors,
                                        },
                                    )?;
                                }

                                buf_output.into_inner()?.persist()?;

                                Ok(())
                            }

                            // This happens when the input resolver cannot establish an input
                            // source, language or query file.
                            Err(error) => Err(error),
                        };

                        if let Err(error) = &result {
                            // By this point, we've lost any reference to the original
                            // input; we trust that it is embedded into `error`.
                            log::warn!("Skipping: {error}");
                        }

                        result
                    });
                }
            });

            if results.len() == 1 {
                // If we just had one input, then handle errors as normal
                results.remove(0)??
            } else if results
                .iter()
                .any(|result| matches!(result, Err(_) | Ok(Err(_))))
            {
                // For multiple inputs, bail out if any failed with a "multiple errors" failure
                return Err(TopiaryError::Bin(
                    "Processing of some inputs failed; see warning logs for details".into(),
                    Some(CLIError::Multiple),
                ));
            }
        }

        Commands::Visualise { format, input } => {
            // We are guaranteed (by clap) to have exactly one input, so it's safe to unwrap
            let input = Inputs::new(&config, &input).next().unwrap()?;
            let output = OutputFile::Stdout;

            // We don't need a `LanguageDefinitionCache` when there's only one input,
            // which saves us the thread-safety overhead
            let language = input.to_language().await?;

            log::info!(
                "Visualising {}, as {}, to {}",
                input.source(),
                input.language().name,
                output
            );

            let mut buf_input = BufReader::new(input);
            let mut buf_output = BufWriter::new(output);

            formatter(
                &mut buf_input,
                &mut buf_output,
                &language,
                Operation::Visualise {
                    output_format: format.into(),
                },
            )?;
        }

        Commands::Config => {
            // Output the collated nickel configuration
            println!("{nickel_config}")
        }

        Commands::Prefetch { force, language } => match language {
            Some(l) => config.prefetch_language(l, force)?,
            _ => config.prefetch_languages(force)?,
        },

        Commands::Coverage { input } => {
            // We are guaranteed (by clap) to have exactly one input, so it's safe to unwrap
            let input = Inputs::new(&config, &input).next().unwrap()?;
            let output = OutputFile::Stdout;

            // We don't need a `LanguageDefinitionCache` when there's only one input,
            // which saves us the thread-safety overhead
            let language = input.to_language().await?;

            log::info!(
                "Checking query coverage of {}, as {}",
                input.source(),
                input.language().name,
            );

            let mut buf_input = BufReader::new(input);
            let mut buf_output = BufWriter::new(output);

            coverage(&mut buf_input, &mut buf_output, &language)?
        }

        Commands::Completion { shell } => {
            // The CLI parser fails if no shell is provided/detected, so it's safe to unwrap here
            cli::completion(shell.unwrap());
        }
    }

    Ok(())
}

fn print_error(e: &dyn Error) {
    log::error!("{e}");
    if let Some(source) = e.source() {
        log::error!("Cause: {source}");
    }
}
