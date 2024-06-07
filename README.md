# dotfiles

Dotfiles and configuration files.

## Installation

To install (symlink) configuration for a particular package, use the
`install.sh` script, e.g.:

```bash
./install.sh ./bash/
```

## Firefox

Firefox is not autmation-friendly and is best configured manually.

Install the following pluggins:
```
https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/
https://addons.mozilla.org/en-US/firefox/addon/fastforwardteam/
https://addons.mozilla.org/en-US/firefox/addon/buster-captcha-solver/
https://addons.mozilla.org/en-US/firefox/addon/greasemonkey/
https://addons.mozilla.org/en-US/firefox/addon/vimium-ff/
https://addons.mozilla.org/en-US/firefox/addon/enhanced-h264ify/
```

Userscripts:
```
https://adsbypasser.github.io/
```

uBlock Origin custom filters:
```
https://www.reddit.com/r/uBlockOrigin/comments/ze9l0s/shorteners_requires_that_you_stay_on_the_tab/
```

In `about:config`:
* `browser.download.useDownloadDir` - set to false to always ask for location
* `media.av1.enabled` - set to false if hardware decoding is not supported
* `media.ffmpeg.vaapi.enabled` - set to true if VA-API is enabled

## Luakit

To pull adblock lists run:
```
~/.local/share/luakit/adblock/update_lists.sh
```

I cannot get HW acceleration to work even with:
```
env GST_PLUGIN_FEATURE_RANK=vah264dec:MAX,vaapih264dec:NONE,avdec_h264:NONE luakit
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

## GnuPG

~/.gnupg permissions may need to be changed:

```bash
chmod 0700 ~/.gnupg
```
