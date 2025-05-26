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
  (explicit_constructor_invocation)
] @allow_blank_line_before

(package_declaration "package" @append_space)
(package_declaration) @append_hardline
(import_declaration
  [
    "import"
    "static"
  ] @append_space
)

(superclass "extends" @prepend_space @append_space)
(super_interfaces "implements" @prepend_space @append_space)
(type_list "," @append_space)
(class_declaration (modifiers) @prepend_space @append_space)
(modifiers
  [
    "public"
    "private"
    "protected"
    "abstract"
    "final"
  ] @append_space
)
(modifiers ["static"] @prepend_space @append_space)
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
(throws "throws" @prepend_space @append_space)

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

(if_statement ["if" "else"] @append_space)
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
  alternative: [
    (block)
    (if_statement)
  ]? @do_nothing
)
(if_statement "else" @prepend_space)

; (condition
;   "(" @append_begin_scope @append_empty_softline @append_indent_start
;   ")" @append_end_scope @prepend_empty_softline @prepend_indent_end
;   (#scope_id! "if_newline")
; )
; (condition
;   "," @append_spaced_scoped_softline
;   (#scope_id! "if_newline")
; )

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

(catch_clause "catch" @prepend_space @append_space)
(catch_type "|" @prepend_space @append_space)
(catch_formal_parameter (catch_type) @append_space)
(finally_clause "finally" @prepend_space @append_space)
(try_statement
  body: (block
    .
    "{" @append_hardline @append_indent_start @prepend_space
    (_)
    "}" @prepend_hardline @prepend_indent_end
    .
  )
)
(catch_clause
  body: (block
    .
    "{" @append_hardline @append_indent_start @prepend_space
    (_)
    "}" @prepend_hardline @prepend_indent_end
    .
  )
)

(try_statement) @append_hardline
(try_statement "try" @append_space)
(try_with_resources_statement "try" @append_space)
(try_with_resources_statement) @append_hardline
(finally_clause
  (block
    .
    "{" @append_hardline @append_indent_start @prepend_space
    (_)
    "}" @prepend_hardline @prepend_indent_end @append_hardline
    .
  )
)
(try_with_resources_statement
  body: (block
    .
    "{" @append_hardline @append_indent_start @prepend_space
    (_)
    "}" @prepend_hardline @prepend_indent_end
    .
  )
)
(resource_specification
  "(" @append_begin_scope @append_empty_softline @append_indent_start
  ")" @append_end_scope @prepend_empty_softline @prepend_indent_end
  (#scope_id! "resource_specification")
)
(resource_specification
  (resource)
  .
  ";" @append_spaced_scoped_softline
  (#scope_id! "resource_specification")
)
(resource "=" @prepend_space @append_space)

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

(switch_expression
  (switch_block
    .
    "{" @append_hardline @append_indent_start @prepend_space
    (_)
    "}" @prepend_hardline @prepend_indent_end
    .
  )
)
(switch_label "case" @append_space)
(labeled_statement) @append_hardline
(switch_block_statement_group) @append_hardline
(labeled_statement ":" @append_space)

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

(argument_list
  "(" @append_begin_scope @append_empty_softline @append_indent_start
  ")" @append_end_scope @prepend_empty_softline @prepend_indent_end
  (#scope_id! "arguments")
)
(argument_list
  "," @append_spaced_scoped_softline
  (#scope_id! "arguments")
)

(formal_parameters
  "(" @append_begin_scope @append_empty_softline @append_indent_start
  ")" @append_end_scope @prepend_empty_softline @prepend_indent_end
  (#scope_id! "form_params")
)
(formal_parameters
  "," @append_spaced_scoped_softline
  (#scope_id! "form_params")
)

; Format arguments
(argument_list "," @append_space)
(formal_parameters "," @append_space)
(throws "," @append_space)
(type_arguments "," @append_space)

(type_arguments (wildcard "extends" @prepend_space @append_space))

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
(resource
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

(binary_expression
  (#scope_id! "bin_expr")
) @prepend_begin_scope @append_end_scope
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
  ] @prepend_spaced_scoped_softline @prepend_indent_start
  right: (_) @append_indent_end
  (#scope_id! "bin_expr")
)


;(argument_list
;  "(" @append_begin_scope @append_empty_softline @append_indent_start
;  ")" @append_end_scope @prepend_empty_softline @prepend_indent_end
;  (#scope_id! "arguments")
;)
;(argument_list
;  "," @append_spaced_scoped_softline
;  (#scope_id! "arguments")
;)

(explicit_constructor_invocation) @append_hardline

(method_invocation
  "." @prepend_indent_start
  arguments: (argument_list ")" @append_indent_end)
  (#scope_id! "invoca")
) @prepend_begin_scope @append_end_scope
(method_invocation
  "." @prepend_spaced_scoped_softline
  (#scope_id! "invoca")
)

(binary_expression
  left: (_) @append_space
  right: (_) @prepend_space
)
(assignment_expression
  left: (_) @append_space
  right: (_) @prepend_space
)

(return_statement "return" @append_space)
(throw_statement "throw" @append_space)

[
  ","
  ";"
  "."
] @prepend_antispace

(object_creation_expression "new" @append_space)
(array_creation_expression "new" @append_space)
(array_creation_expression (dimensions) @append_space)
