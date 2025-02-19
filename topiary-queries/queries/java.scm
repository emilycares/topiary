; Allow blank line before
[
  (import_declaration)
  (class_declaration)
  (expression_statement)
] @allow_blank_line_before

(package_declaration "package" @append_space)
(import_declaration "import" @append_space)

(class_declaration (modifiers) @append_space)
(class_declaration "class" @append_space)
(class_declaration (identifier) @append_space)

; Indent the declarations in the class
(class_body
  .
  "{" @append_hardline @append_indent_start @prepend_space
  (_)
  "}" @prepend_hardline @prepend_indent_end @append_hardline
  .
)

(method_declaration
  (block
    .
    "{" @append_hardline @append_indent_start @prepend_space
    (_)
    "}" @prepend_hardline @prepend_indent_end @append_hardline
    .
  )
)

(for_statement
  (block
    .
    "{" @append_hardline @append_indent_start @prepend_space
    (_)
    "}" @prepend_hardline @prepend_indent_end @append_hardline
    .
  )
)

(enhanced_for_statement
  (block
    .
    "{" @append_hardline @append_indent_start @prepend_space
    (_)
    "}" @prepend_hardline @prepend_indent_end @append_hardline
    .
  )
)

(lambda_expression
  (block
    .
    "{" @append_hardline @append_indent_start @prepend_space
    (_)
    "}" @prepend_hardline @prepend_indent_end
    .
  )
)
(lambda_expression "->" @prepend_space @append_space)

[
  (field_declaration ";")
  (expression_statement ";")
  (marker_annotation)
  (annotation)
] @append_spaced_softline

(_
  (local_variable_declaration ";") @append_spaced_scoped_softline
  (#scope_id! "varsemi")
) @prepend_begin_scope @append_end_scope
; No newline after local_variable_declaration in for_statement
(for_statement
  init: (local_variable_declaration
    ";"
  ) @prepend_begin_scope @append_end_scope @append_empty_scoped_softline
  (#scope_id! "varsemi")
)
[
  (return_statement)
  (import_declaration)
  (field_declaration)
] @prepend_hardline

[
  (import_declaration)
  (class_declaration)
  (return_statement)
  (method_declaration)
  (field_declaration)
  (line_comment)
  (block_comment)
] @allow_blank_line_before

; Format arguments
(argument_list "," @append_space)
(formal_parameters "," @append_space)

; Input softlines before and after all comments. This means that the input
; decides if a comment should have line breaks before or after. A line comment
; always ends with a line break.
[
  (block_comment)
  (line_comment)
] @prepend_input_softline

[
  "static"
] @prepend_space @append_space

(method_declaration
  type: [
    (type_identifier)
    (generic_type)
    (integral_type)
  ] @prepend_space @append_space
)
(field_declaration
  type: [
    (type_identifier)
    (generic_type)
    (integral_type)
  ] @prepend_space @append_space
)
(local_variable_declaration
  type: [
    (type_identifier)
    (generic_type)
    (integral_type)
  ] @append_space
)
(formal_parameter
  type: [
    (type_identifier)
    (generic_type)
    (integral_type)
  ] @append_space
)
(enhanced_for_statement
  type: [
    (type_identifier)
    (generic_type)
    (integral_type)
  ] @append_space
)
(for_statement ";" @append_antispace)
(enhanced_for_statement ":" @prepend_space @append_space)
(variable_declarator "=" @prepend_space @append_space)

(binary_expression
  [
    "+"
    "-"
    "*"
    "/"
    "%"
    "="
    "+="
    "-="
    "*="
    "/="
    "%="
    "&="
    "|="
    "^="
    ">>="
    "<<="
    "=="
    "!="
    ">"
    "<"
    ">="
    "<="
    "&&"
    "||"
    "!"
  ] @prepend_space @append_space
)

(return_statement "return" @append_space)

[
  ","
  ";"
  "."
] @prepend_antispace

(object_creation_expression "new" @append_space)
