# dotfiles

<!--toc:start-->
- [dotfiles](#dotfiles)
  - [Active used configs](#active-used-configs)
    - [Neovim lua config](#neovim-lua-config)
    - [lazygit](#lazygit)
    - [wezterm](#wezterm)
    - [eza](#eza)
    - [zoxide](#zoxide)
    - [delta](#delta)
    - [bat](#bat)
    - [stow](#stow)
  - [Colors](#colors)
  - [Scripts](#scripts)
    - [cht.sh](#chtsh)
    - [nvim-open](#nvim-open)
  - [Fallback config](#fallback-config)
    - [vimrc](#vimrc)
<!--toc:end-->

My config files

## Active used configs

### Neovim lua config
After using several IDEs and Vim I ended up using Neovim as my PDE (Personal Development Environment.)
[Neovim Readme](.config/nvim/README.md)

### lazygit
My preferred way to deal with my git repos. I even have a neovim plugin to have it all the time right at my
fingertips.
Lazygit is integrated into my neovim config using snacks.nvim and I use it as a git client.
[lazygit config](./config/lazygit/config.yml)
On MacOS is the config located at '~/Library/Application Support/lazygit/config.yml'

```bash
ln -s ~/Repos/dotfiles/.config/lazygit/config.yml ~/Library/Application Support/lazygit/config.yml
```

### wezterm
After using a bunch of terminal emulators and multiplexers I'm currently using wezterm.
Following points were my reason to switch:
 - configuration is written in lua. Same as neovim.
 - highly customizable using lua
 - no need to use a multiplexer
 - supports kitty image protocol
 - fast and lightweight

### eza
A modern replacement for the ls command. It is written in rust and has a lot of features.
I use it as my default ls command. 

### zoxide
A smarter cd command with memory. It is written in rust and I use it as a in-place replacement cd command.

### delta
A viewer for git and diff output. I use it as my default git diff viewer.

### bat
A cat clone with syntax highlighting and git integration. I use it as my default cat command.

### stow
I use stow to manage my dotfiles. It is a symlink farm manager. I reorganized my dotfiles to use stow.
Youtube Video
https://youtu.be/y6XCebnB9gs?si=cisaCuaYR3tC28Qm

Usage: 
```bash
cd ~/Repos/dotfiles/
stow .
```

## Colors

My preferred colorscheme is **gruvbox dark**. Therefore I have the colors as iTerm colors and in a simply json format.
I use these colors in my wezterm statusbar, lazygit, bat, delta and neovim.

## Scripts

### cht.sh

This script can be used to look up information from the cht.sh website.

### nvim-open

`nvim-open` opens an existing document in the matching running Neovim instance,
moves the cursor to a requested line and column, switches to the pane's WezTerm
workspace, and focuses the pane that contains that instance. It is intended for
integrations with desktop tools that know a document path and source position.

#### Requirements and installation

The integration is designed for local Neovim instances running in WezTerm on
macOS. It requires `nvim`, `wezterm`, and `jq`; all three are included in the
Brewfile. Install the dotfiles links and restart the relevant Neovim instances:

```bash
cd ~/Repos/dotfiles
stow .
```

Stow exposes the executable as `~/scripts/nvim-open`. A desktop application
should use the absolute path because applications launched by macOS do not
necessarily inherit the interactive shell's `PATH`.

#### Command-line usage

```text
nvim-open <file> <line> [column]
```

Line and column are 1-based; the column defaults to `1`:

```bash
~/scripts/nvim-open ~/Repos/example/src/main.cpp 42
~/scripts/nvim-open ~/Repos/example/src/main.cpp 42 7
```

The document must already exist. The command never starts a new Neovim
instance. On success it exits with status `0`. Invalid arguments, no matching
instance, RPC failures, and WezTerm focus failures are written to standard error
and return a non-zero status. Run `nvim-open --help` for a short reference.

Each Neovim instance treats its startup directory as its project root. The
dispatcher selects the longest root that contains the requested document, so a
nested project wins over its parent project. If several instances use the same
root, the currently focused matching WezTerm pane wins; otherwise the Neovim
instance most recently receiving focus is used.

#### Calling it from Qt

Use `QProcess::start()` with a program and a `QStringList`, not `system()`,
`startCommand()`, or a manually quoted command string. This preserves paths with
spaces and other special characters as a single argument and provides stderr
and the exit status asynchronously.

The following example assumes that `showEditorError()` displays a non-modal
toast or status message:

```cpp
#include <QDir>
#include <QProcess>
#include <QTimer>

void EditorBridge::openDocument(const QString& file, int line, int column)
{
    auto* process = new QProcess(this);
    auto* timeout = new QTimer(process);
    timeout->setSingleShot(true);

    process->setProgram(QDir::home().filePath("scripts/nvim-open"));
    process->setArguments({
        file,
        QString::number(line),
        QString::number(column),
    });

    connect(timeout, &QTimer::timeout, process, [process]() {
        process->setProperty("nvimOpenTimedOut", true);
        process->terminate();
        QTimer::singleShot(500, process, [process]() {
            if (process->state() != QProcess::NotRunning)
                process->kill();
        });
    });

    connect(process, &QProcess::errorOccurred, this,
            [this, process, timeout](QProcess::ProcessError error) {
        if (error != QProcess::FailedToStart)
            return;

        timeout->stop();
        showEditorError(tr("Could not start Neovim integration: %1")
                            .arg(process->errorString()));
        process->deleteLater();
    });

    connect(process,
            qOverload<int, QProcess::ExitStatus>(&QProcess::finished), this,
            [this, process, timeout](int exitCode,
                                     QProcess::ExitStatus exitStatus) {
        timeout->stop();
        const bool timedOut = process->property("nvimOpenTimedOut").toBool();
        if (timedOut) {
            showEditorError(tr("Opening the document in Neovim timed out."));
        } else if (exitStatus != QProcess::NormalExit || exitCode != 0) {
            QString message = QString::fromUtf8(process->readAllStandardError()).trimmed();
            if (message.isEmpty())
                message = tr("Could not open the document in Neovim.");
            showEditorError(message);
        }
        process->deleteLater();
    });

    process->start();
    timeout->start(5000);
}
```

If column information is unavailable, pass `1` or omit the third argument when
constructing the argument list.

#### Troubleshooting

- **No remote-enabled Neovim instances:** run `stow .`, restart Neovim inside
  WezTerm, and verify that `~/.cache/nvim/remote-open` contains a socket.
- **No matching instance:** ensure the document is located below the directory
  from which the intended Neovim instance was started. A later `:cd` does not
  change that registered root.
- **The helper cannot be started:** verify that `~/scripts/nvim-open` exists and
  is executable. Use its absolute path from a desktop application.
- **The file opens but WezTerm is not focused:** ensure the instance is local,
  its original WezTerm GUI is still running, and `wezterm cli list` succeeds.
- **Stale sockets after a crash:** the next invocation probes and removes
  unreachable sockets automatically.

For tests or non-standard installations, dependency paths can be overridden
with `NVIM_OPEN_NVIM`, `NVIM_OPEN_WEZTERM`, `NVIM_OPEN_JQ`, and
`NVIM_OPEN_OPEN`. `NVIM_OPEN_SOCKET_DIR` overrides the registry directory.
The Neovim-side implementation is described in
[the Neovim configuration README](.config/nvim/README.md#remote-document-opening).

## Fallback config

### vimrc
I stripped down my .vimrc to a minimal one-file configuration without any external
dependencies. No package manager is used. So it can easily be copied to any
machine and I have a really good base to work with within seconds.
