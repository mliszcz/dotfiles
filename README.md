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

## Calendar and contacts

Data is stored locally, but can be accessed via CalDAV/CardDav with `radicale`.

* Install packages: `radicale`, `khal`, `khard`, `todoman`
* Create data dirs: `~/.local/share/radicale/collection-root/$USER/{calendar,contacts,tasks}`

