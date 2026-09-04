# AGENTS.md

## Repository purpose

This repository contains personal dotfiles for macOS and Linux. GNU Stow links the repository contents into `$HOME`; `.stowrc` sets the target and enables dotfile handling. Treat paths in this repository as their eventual paths below the user's home directory.

The main maintained areas are:

- `.config/nvim/`: Neovim configuration written in Lua
- `.config/wezterm/`: WezTerm configuration written in Lua
- `.config/Brewfile`: Homebrew bundle and application inventory
- `.zshrc`, `.zsh.aliases`, `.zsh.functions`: Zsh configuration
- `.gitconfig`, `.gitmux.conf`, `.vimrc`: tool configuration
- `scripts/`: user-facing command-line helpers

Read the root `README.md` before changing installation behavior or documented workflows.

## General working rules

- Make focused changes and preserve the existing organization. Do not broadly rewrite unrelated personal preferences.
- Follow conventions in neighboring files before introducing a new pattern, dependency, key mapping, or module.
- Prefer portable configuration, but preserve macOS-specific behavior where the surrounding code intentionally depends on macOS, Homebrew, or WezTerm.
- Do not run `stow .` as a validation command: it changes links in the real home directory. Use a dry run when checking Stow behavior.
- Never add credentials, tokens, private keys, shell history, machine-specific state, absolute paths containing another user's home directory, or application-generated caches.
- Preserve executable bits on scripts.
- Update `README.md` when a user-visible command, prerequisite, installation step, or workflow changes.
- Do not commit changes unless explicitly requested.

## Generated and local files

Respect `.gitignore`. In particular, do not deliberately add or edit generated/local state such as:

- `.config/nvim/lazy-lock.json`
- `.config/nvim/nvim-pack-lock.json`
- `.config/nvim/.undo/`
- `.config/lazygit/state.yml`
- `.config/github-copilot/`
- `.zsh.local`
- Nushell history and local weathr data

Before finishing, inspect the diff and verify that no secrets, host-specific values, generated artifacts, or unrelated formatter churn were introduced.

## Style and implementation conventions

### Lua

- Follow `.stylua.toml` and `.editorconfig`.
- Use three-space indentation, single quotes, a 120-column limit, and parentheses on function calls.
- Keep comments in English.
- Prefer small modules with explicit `require(...)` calls and a returned table where that matches adjacent files.
- Neovim plugin specifications belong in `.config/nvim/lua/plugins/`; keep plugin setup and key mappings close to the relevant plugin unless an existing shared module owns them.
- Key mappings should normally include a useful `desc`; preserve the repository's which-key-friendly description style.
- Avoid adding compatibility shims unless the supported Neovim or WezTerm version requires them.

### Shell scripts and Zsh configuration

- Preserve the existing interpreter and shell dialect; do not convert between Bash and Zsh without a reason.
- Quote variable expansions and paths unless intentional word splitting is required.
- Return non-zero status for failures and send actionable error messages to stderr.
- For public scripts, keep `--help`, argument validation, and documented behavior synchronized.
- Prefer existing Homebrew-provided tools over adding ad hoc installers.

### Structured configuration

- Preserve established indentation and key ordering in TOML, YAML, JSON, Git config, and application-specific files.
- Avoid reformatting large generated JSON files such as Karabiner exports unless the task specifically requires it.
- When adding a required command-line tool or application, update `.config/Brewfile` and relevant documentation together.

## Component notes

### Neovim

- `.config/nvim/init.lua` is the entry point. Core behavior is split across modules in `.config/nvim/lua/`; plugin specifications are discovered from `lua/plugins/` by lazy.nvim.
- LSP overrides live in `.config/nvim/after/lsp/`; filetype-specific settings live in `.config/nvim/after/ftplugin/`.
- External formatter mappings live in `.config/nvim/lua/plugins/conform.lua`; keep domain-specific HCL formatting separate (`packer fmt`, `terraform fmt`, and `hclfmt`).
- The Snacks buffer picker extends the built-in buffer formatter in `.config/nvim/lua/plugins/snacks.lua` to show per-severity diagnostic counts right-aligned.
- Do not manually edit plugin lock files unless the task is specifically about dependency locking.
- Headless startup may bootstrap or update plugins and can require network access. Prefer syntax and formatting checks for isolated changes; only perform a full startup check when its side effects are acceptable.

### WezTerm

- `.config/wezterm/wezterm.lua` is the entry point.
- Keep reusable behavior under `layouts/` or `utils/`, and keep key bindings in `keymappings.lua` when practical.
- Preserve the shared navigation behavior between WezTerm and Neovim.

### GNU Stow

- `.stowrc` targets `~` and uses dotfile mode.
- Check link changes without applying them:

  ```sh
  stow --simulate --verbose .
  ```

- Do not remove or overwrite existing user files to resolve a Stow conflict unless explicitly instructed.

## Validation

There is no repository-wide automated test suite. Run the smallest relevant checks for the files changed, and report any unavailable tools or checks that cannot safely run.

### Lua formatting and syntax

```sh
stylua --check .config/nvim .config/wezterm
find .config/nvim .config/wezterm -name '*.lua' -print0 | xargs -0 -n1 luac -p
```

For a focused change, pass only the changed Lua files to `stylua --check` and `luac -p`. Be aware that WezTerm's Lua runtime and Neovim's Lua runtime expose globals that plain Lua does not; syntax checking is still useful, but executing those files with `lua` is not a valid integration test.

When appropriate and when plugin/network side effects are acceptable, check Neovim startup with:

```sh
nvim --headless '+qa'
```

### Shell syntax

Use the interpreter matching each file's shebang or purpose. Typical checks are:

```sh
zsh -n .zshrc .zsh.aliases .zsh.functions
bash -n scripts/cht.sh
```

For other scripts, run the corresponding shell with `-n`. Also exercise `--help` and error paths when changing command-line behavior.

### Homebrew and Stow

```sh
brew bundle check --file=.config/Brewfile
stow --simulate --verbose .
```

`brew bundle check` reports missing local dependencies and may not pass on a partially provisioned machine; treat that as an environment result rather than modifying the Brewfile solely to silence it.

## Completion checklist

1. Review `git diff` for scope, accidental personal data, generated files, and unrelated formatting.
2. Run formatting and syntax checks relevant to every changed file type.
3. Run focused functional checks where they are safe and practical.
4. Update documentation for user-visible changes.
5. Summarize changed files, validation performed, and any checks skipped or blocked by the local environment.

