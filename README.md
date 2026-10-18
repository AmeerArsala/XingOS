# dotfiles

niri + Noctalia (v5) + ghostty on Fedora, plus fcitx5 pinyin, helix, yazi, starship, zsh, and greetd.
Based on shen-nm/niri-config and nixxoq/dotfiles.

The repo is managed by `dots`, a small copy-based script (no symlinks, so apps that rewrite their own
config, like Noctalia, can't break anything). It needs only `bash`, `rsync` and `git`.

## Layout

    dots           the CLI (symlinked to ~/.local/bin/dots)
    manifest       list of tracked paths and excludes
    home/          copies of files under $HOME
    system/        snapshots of system files (/etc/...)

## The `dots` CLI

### `dots` / `dots sync` — save your current setup
Copies every tracked live file into the repo, commits if anything changed, and (if a remote exists)
asks whether to push. Files deleted on your system are removed from the repo too.

    dots                       # sync, default commit message
    dots -m "tweak binds"      # custom commit message
    dots -p                    # push without asking
    dots -n                    # never push (just commit)

Default message: `sync: <date> on <hostname>`. With no changes it prints "Nothing changed."
With no remote it prints the `git remote add origin <url>` command to set one up.

### `dots status` — preview changes
Lists what differs between your live files and the repo (and any tracked path not in the repo yet).
Changes nothing.

### `dots apply` — restore onto a machine
Copies the repo back to its real locations. Anything it would overwrite is backed up first to
`~/.dots-backup/<timestamp>/`. It also symlinks `dots` into `~/.local/bin` and clones upstream
oh-my-zsh if `~/.oh-my-zsh` is missing.

    dots apply                 # user files only
    dots apply --system        # also restore /etc files (asks for sudo), e.g. /etc/greetd/config.toml

### `dots add PATH` — track something new
Adds a file or directory to `manifest`. Paths under $HOME can be given absolute or relative to $HOME;
absolute paths outside $HOME are treated as system files. Run `dots` afterwards to snapshot it.

    dots add ~/.config/btop
    dots add /etc/some/system.conf

### `dots help` — print the short usage text

## The manifest

`manifest` has one path per line:

- `.config/niri` — relative to `$HOME`, file or directory
- `/etc/greetd/config.toml` — absolute path, stored under `system/`
- `!cached_layouts` — rsync exclude pattern for generated/cache files
- `# comment`

To stop tracking something, delete its line and its copy under `home/` (or `system/`), then run `dots`.

## New machine

    git clone <your-remote> ~/dotfiles
    ~/dotfiles/dots apply --system

Notes: oh-my-zsh itself is not stored here (`.zshrc` is; `apply` clones upstream). Noctalia keeps
UI-changed settings in `~/.local/state/noctalia/settings.toml`, which overrides `~/.config/noctalia/config.toml`;
both are tracked.
