" YAML fixers
let b:ale_fixers = ['prettier','yamlfix','yamlfmt','remove_trailing_lines','trim_whitespace']
let g:ale_yaml_yamllint_options='-d "{extends: relaxed, rules: {line-length: disable}}"'
