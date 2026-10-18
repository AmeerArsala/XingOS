# dotfiles

niri + Noctalia (v5) + ghostty on Fedora, plus fcitx5 pinyin, helix, yazi, starship, and greetd.
Based on shen-nm/niri-config and nixxoq/dotfiles.

Copy-based (no symlinks), so apps that rewrite their own config (Noctalia, ghostty themes) can't break the repo.

    dots            # copy live files into the repo, commit, offer to push
    dots status     # what differs
    dots apply      # restore repo -> live (backs up to ~/.dots-backup/)
    dots apply --system   # also restore /etc files (sudo)
    dots add PATH   # track another file/dir

oh-my-zsh itself is not vendored: `.zshrc` is tracked and `dots apply` clones upstream oh-my-zsh if missing.

Tracked paths live in `manifest`. Fresh machine: clone, then `./dots apply` (it symlinks itself to ~/.local/bin/dots).
