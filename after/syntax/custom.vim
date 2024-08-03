syntax match CustomDot "\."
syntax match CustomValue "\<[a-zA-Z_][a-zA-Z0-9_]*\(\.[a-zA-Z_][a-zA-Z0-9_]*\)\+\>"
highlight link CustomDot Identifier
highlight link CustomValue Constant
