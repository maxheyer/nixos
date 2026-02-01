{ pkgs, ... }:

{
  home.packages = with pkgs; [
  # LSP - Web Development
  typescript-language-server
  vscode-langservers-extracted
  tailwindcss-language-server
  emmet-ls
  svelte-language-server
  vue-language-server
  
  # LSP - Python
  pyright
  ruff
  
  # LSP - Rust
  rust-analyzer
  
  # LSP - C/C++
  clang-tools
  
  # LSP - Go
  gopls
  golangci-lint-langserver
  
  # LSP - Lua
  lua-language-server
  
  # LSP - Nix
  nil
  nixd
  
  # LSP - Bash/Shell
  bash-language-server
  
  # LSP - Docker
  dockerfile-language-server
  docker-compose-language-service
  
  # LSP - Markup/Config
  yaml-language-server
  taplo
  marksman
  markdownlint-cli2
  
  # LSP - Database
  sqls
  
  # LSP - GraphQL
  graphql-language-service-cli
  
  # LSP - Java
  jdt-language-server
  
  # LSP - C#
  omnisharp-roslyn
  
  # LSP - PHP
  phpactor
  
  # LSP - Ruby
  solargraph
  
  # LSP - Zig
  zls
  
  # LSP - Haskell
  haskell-language-server
  
  # Formatter - Multi-language
  prettier
  
  # Formatter - Nix
  nixfmt-rfc-style
  alejandra
  nixpkgs-fmt
  
  # Formatter - Python
  black
  isort
  
  # Formatter - Rust
  rustfmt
  
  # Formatter - Go
  gofumpt
  golines
  
  # Formatter - Lua
  stylua
  
  # Formatter - Shell
  shfmt
  
  # Formatter - SQL
  #sqlfluff
  pgformatter
  
  # Formatter - Other
  xmlformat
  cmake-format
  terraform
  buf
  
  # Linter - Multi-language
  codespell
  
  # Linter - JavaScript/TypeScript
  eslint_d
  
  # Linter - Python
  ruff
  pylint
  mypy
  
  # Linter - Lua
  luajitPackages.luacheck
  selene
  
  # Linter - Shell
  shellcheck
  
  # Linter - Markdown
  markdownlint-cli
  vale
  
  # Linter - YAML
  yamllint
  
  # Linter - Nix
  statix
  deadnix
  
  # Linter - Go
  golangci-lint
  
  # Linter - C/C++
  cppcheck
  
  # Linter - Docker
  hadolint
  
  # Linter - Terraform
  tflint
  
  # Linter - CSS
  stylelint
  
  # DAP - Python
  python3Packages.debugpy
  
  # DAP - Go
  delve
  
  # DAP - C/C++/Rust
  lldb
  gdb
  
  # DAP - .NET/C#
  netcoredbg
  
  # Tools
  tree-sitter
  ripgrep
  fd
  lazygit
  xclip
  wl-clipboard
];
}
