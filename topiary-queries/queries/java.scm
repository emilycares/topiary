; Allow blank line before
[
  (import_declaration)
  (interface_declaration)
  (enum_declaration)
  (class_declaration)
  (expression_statement)
  (local_variable_declaration)
  (for_statement)
  (enhanced_for_statement)
  (if_statement)
  (constant_declaration)
] @allow_blank_line_before

(package_declaration "package" @append_space)
(package_declaration) @append_hardline
(import_declaration "import" @append_space)

(superclass "extends" @prepend_space @append_space)
(super_interfaces "implements" @prepend_space @append_space)
(type_list "," @append_space)
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

(interface_body
  .
  "{" @append_hardline @append_indent_start @prepend_space
  (_)
  "}" @prepend_hardline @prepend_indent_end @append_hardline
  .
)
(interface_declaration "interface" @prepend_space @append_space)
(constant_declaration
  (modifiers) @append_space
)
(constant_declaration
  type: (type_identifier) @append_space
)
(constant_declaration) @append_hardline

(line_comment) @append_hardline
(
  (block_comment) @append_hardline
  .
  [
    (method_declaration)
    (interface_declaration)
    (class_declaration)
    (enum_declaration)
    (package_declaration)
    (constructor_declaration)
    (constant_declaration)
  ]
)

(enum_declaration "enum" @prepend_space @append_space)
(enum_body "," @append_hardline)
(enum_body
  .
  "{" @append_hardline @append_indent_start @prepend_space
  (_)
  "}" @prepend_hardline @prepend_indent_end @append_hardline
  .
)

(method_declaration (throws) @prepend_space)
(throws "throws" @append_space)

(method_declaration
  (block
    .
    "{" @append_hardline @append_indent_start @prepend_space
    (_)
    "}" @prepend_hardline @prepend_indent_end @append_hardline
    .
  )
)

(constructor_declaration
  body: (constructor_body
    .
    "{" @append_hardline @append_indent_start @prepend_space
    (_)
    "}" @prepend_hardline @prepend_indent_end @append_hardline
    .
  )
)

(constructor_declaration name: (identifier) @prepend_space)

(for_statement
  (block
    .
    "{" @append_hardline @append_indent_start @prepend_space
    (_)
    "}" @prepend_hardline @prepend_indent_end @append_hardline
    .
  )
)
(for_statement "for" @append_space)
(for_statement ";" @append_space)

(enhanced_for_statement
  (block
    .
    "{" @append_hardline @append_indent_start @prepend_space
    (_)
    "}" @prepend_hardline @prepend_indent_end @append_hardline
    .
  )
)

(if_statement "if" @append_space)
(if_statement
  consequence: (block
    .
    "{" @append_hardline @append_indent_start @prepend_space
    (_)
    "}" @prepend_hardline @prepend_indent_end
    .
  )
)
(if_statement
  alternative: (block
    .
    "{" @append_hardline @append_indent_start @prepend_space
    (_)
    "}" @prepend_hardline @prepend_indent_end @append_hardline
    .
  )
)
(if_statement
  consequence: (block "}") @append_spaced_softline
  alternative: (block)? @do_nothing
)
(if_statement "else" @prepend_space)

(while_statement "while" @append_space)
(while_statement
  body: (block
    .
    "{" @append_hardline @append_indent_start @prepend_space
    (_)
    "}" @prepend_hardline @prepend_indent_end @append_hardline
    .
  )
)

(do_statement
  body: (block
    .
    "{" @append_hardline @append_indent_start @prepend_space
    (_)
    "}" @prepend_hardline @prepend_indent_end
    .
  )
)
(do_statement "while" @prepend_space @append_space) @append_hardline

(try_statement (catch_clause "catch" @prepend_space @append_space))
(try_statement (finally_clause "finally") @prepend_space)
(try_statement
  body: (block
    .
    "{" @append_hardline @append_indent_start @prepend_space
    (_)
    "}" @prepend_hardline @prepend_indent_end
    .
  )
)
(try_statement
  (catch_clause
    body: (block
      .
      "{" @append_hardline @append_indent_start @prepend_space
      (_)
      "}" @prepend_hardline @prepend_indent_end @append_hardline
      .
    )
  )
)
(try_statement
  (finally_clause
    (block
      .
      "{" @append_hardline @append_indent_start @prepend_space
      (_)
      "}" @prepend_hardline @prepend_indent_end @append_hardline
      .
    )
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
] @append_spaced_softline

[
  (marker_annotation)
  (annotation)
] @append_hardline

(local_variable_declaration (modifiers) @append_space)

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
(throws "," @append_space)

(modifiers ["static" "final"] @prepend_space @append_space)

(method_declaration
  type: [
    (type_identifier)
    (generic_type)
    (integral_type)
    (boolean_type)
    (array_type)
    (void_type)
  ] @prepend_space @append_space
)
(field_declaration
  type: [
    (type_identifier)
    (generic_type)
    (integral_type)
    (boolean_type)
    (array_type)
  ] @prepend_space @append_space
)
(local_variable_declaration
  type: [
    (type_identifier)
    (generic_type)
    (integral_type)
    (boolean_type)
    (array_type)
  ] @append_space
)
(formal_parameter
  type: [
    (type_identifier)
    (generic_type)
    (integral_type)
    (boolean_type)
    (array_type)
  ] @append_space
)
(enhanced_for_statement
  type: [
    (type_identifier)
    (generic_type)
    (integral_type)
    (boolean_type)
    (array_type)
  ] @append_space
)
(enhanced_for_statement "for" @append_space)
(enhanced_for_statement ":" @prepend_space @append_space)
(variable_declarator "=" @prepend_space @append_space)

(assignment_expression
  [
    "="
    "+="
    "-="
    "*="
    "/="
    "%="
    "&="
    "|="
    "^="
  ] @prepend_space @append_space
)

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
(throw_statement "throw" @append_space)

[
  ","
  ";"
  "."
] @prepend_antispace

(object_creation_expression "new" @append_space)

(assignment_expression "=" @prepend_space @append_space)
