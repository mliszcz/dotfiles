# dotfiles

Dotfiles and configuration files.

## Installation

To install (symlink) configuration for a particular package, use the
`install.sh` script, e.g.:

```bash
./install.sh ./bash/
```

## `git` completion

Bash autocompletion scripts are usually bundled with the `git` package:

* Arch Linux: `/usr/share/git/completion`
* Fedora: `/usr/share/git-core/contrib/completion`
* Ubuntu: missing
* upstream:
  * <https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash>
  * <https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh>

If necessary, manually fix these symlinks in `~/.bashrc.d`.

## `khal` (CalDAV) and `khard` (CardDAV)

These are available in AUR, but can be installed with `pip` as well, provided
that following packages are present:

`python-virtualenv`, `libxml2`, `libxslt`, `lxml`, `zlib`

```bash
VENV=~/.local/share/khal-khard-vdirsyncer
mkdir -p $VENV
virtualenv $VENV
$VENV/bin/pip install khal khard vdirsyncer
ln -s ~/.local/share/khal-khard-vdirsyncer/bin/{khal,ikhal,khard,vdirsyncer} ~/.local/bin/
```
