use std::{
    ffi::OsString,
    io::{stdout, Write},
};
use tempfile::NamedTempFile;
use topiary::FormatterResult;

#[derive(Debug)]
pub enum OutputFile {
    Stdout,
    Disk {
        // NOTE We stage to a file, rather than writing
        // to memory (e.g., Vec<u8>), to ensure atomicity
        staged: NamedTempFile,
        output: OsString,
    },
}

impl OutputFile {
    pub fn new(path: Option<&str>) -> FormatterResult<Self> {
        match path {
            Some("-") | None => Ok(Self::Stdout),
            Some(file) => Ok(Self::Disk {
                staged: NamedTempFile::new()?,
                output: file.into(),
            }),
        }
    }

    // This function must be called to persist the output to disk
    pub fn persist(self) -> FormatterResult<()> {
        if let Self::Disk { staged, output } = self {
            staged.persist(output)?;
        }

        Ok(())
    }
}

impl Write for OutputFile {
    fn write(&mut self, buf: &[u8]) -> std::io::Result<usize> {
        match self {
            Self::Stdout => stdout().write(buf),
            Self::Disk { staged, .. } => staged.write(buf),
        }
    }

    fn flush(&mut self) -> std::io::Result<()> {
        match self {
            Self::Stdout => stdout().flush(),
            Self::Disk { staged, .. } => staged.flush(),
        }
    }
}