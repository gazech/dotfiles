# objectively best dotfiles


## Set Environment

Optional; will be sourced by the other scripts if `DOTFILE_BACKUP_EXTENSION` or `DOTFILE_DST_DIR` do not exist in the current shell environment.

```bash
. ./.dfinit.sh 
```

## Installation
```bash
. ./make_symlinks.sh
```

## Purge (Unlink) any existing backup links

This **will not** remove any backup *files*, only *links*.

```bash
. ./purge_backups.sh
```
