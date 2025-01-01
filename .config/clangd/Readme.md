https://clangd.llvm.org/config

Files
Configuration is stored in YAML files. These are either:

project configuration: a file named .clangd in the source tree. (clangd searches in all parent directories of the active file).

Generally this should be used for shared and checked-in settings.

(Existing directories named .clangd can be deleted. These were used for temporary storage by clangd before version 11.)

user configuration: a config.yaml file in an OS-specific directory:

Windows: %LocalAppData%\clangd\config.yaml, typically C:\Users\Bob\AppData\Local\clangd\config.yaml.
macOS: ~/Library/Preferences/clangd/config.yaml
Linux and others: $XDG_CONFIG_HOME/clangd/config.yaml, typically ~/.config/clangd/config.yaml.
Private settings go here, and can be scoped to projects using If conditions.

Each file can contain multiple fragments separated by --- lines. (This is only useful if the fragments have different If conditions).

JSON is a subset of YAML, so you can use that syntax if you prefer.

Changes should take effect immediately as you continue to edit code.


