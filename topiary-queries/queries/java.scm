; Allow blank line before
[
 (import_declaration)
 (class_declaration)
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

(method_declaration (block
  .
  "{" @append_hardline @append_indent_start @prepend_space
  (_)
  "}" @prepend_hardline @prepend_indent_end @append_hardline
  .
))

[
 ";"
 (marker_annotation)
 (annotation)
] @append_hardline

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


; Input softlines before and after all comments. This means that the input
; decides if a comment should have line breaks before or after. A line comment
; always ends with a line break.
[
  (block_comment)
  (line_comment)
] @prepend_input_softline

[
 "static"
 (type_identifier)
] @prepend_space @append_space


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

