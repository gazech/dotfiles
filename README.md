# objectively best dotfiles


## Set Environment

Optional; will be sourced by the other scripts if `DOTFILE_BACKUP_EXTENSION` or `DOTFILE_DST_DIR` do not exist in the current shell environment.

```bash
. ./.dfinit.sh 
```

## Installation

### Preview changes (dry-run)
```bash
./make_symlinks.sh --dry-run
```

### Install dotfiles
```bash
./make_symlinks.sh
```

### Install to custom directory
```bash
DOTFILE_DST_DIR=/path/to/target ./make_symlinks.sh
```

## Purge (Unlink) any existing backup links

This **will not** remove any backup *files*, only *links*.

### Preview what would be deleted
```bash
./purge_backups.sh --dry-run
```

### Remove backup links
```bash
./purge_backups.sh
```

## Command-line Options

Both scripts support the following options:

- `-n, --dry-run` - Preview changes without making any modifications
- `-h, --help` - Display usage information

## Environment Variables

- `DOTFILE_DST_DIR` - Target directory for symlinks (default: `~`)
- `DOTFILE_BACKUP_EXTENSION` - Backup file suffix (default: `.bak`)
