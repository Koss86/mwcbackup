# My Winter Car Back-up

A bash script for Linux users to back up My Winter Car save files.

## Setup

#### Install Location

If you installed MWC into the default location `~/.local/share/Steam` then you don't need to do anything.

But, if you installed MWC into a Steam Library you will need to edit `steam_lib` at the top of `mwcbackup.sh` to point to the Library's location.

For example:

On my dekstop, MWC is installed in a Steam Library located at `/mnt/ssd-1tb/SteamLibrary/`.

So my `steam_lib` for my dekstop must be `steam_lib="/mnt/ssd-1tb/SteamLibrary/"`.

#

#### Alias

I recommend setting up an alias in your .bashrc file, normally located at `~/.bashrc`.

Copy and paste the snippet below into your .bashrc.

Replace `path/to` with the path to mwcbackup.sh on your system then save and restart your terminal.

```sh
# Replace 'path/to' with acutal path.
alias mwcbackup='path/to/mwcbackup.sh'
```

Now mwcbackup.sh can be called from anywhere by typing `mwcbackup` as if it was
in your $PATH.

#

#### Path

If you're in the same directory as the script, you can simply type `./mwcbackup.sh` in your terminal to run it.

But an easier way is to move mwcbackup.sh somewhere thats in your $PATH.

Use the command `echo $PATH` to see directories that are in your $PATH.

Once the script is in your $PATH, you can call the script from anywhere by typing `mwcbackup.sh` in your terminal.

## Usage

Use these commands in your termainal to back up, restore, or remove your backed up saves.

If you are using the Path method above, use `mwcbackup.sh` instead of `mwcbackup`.

- `mwcbackup` will copy MWC saves into '~/Documents/mwc-backups/mwc-backup'.

- `mwcbackup alt [dirname]` will copy MWC saves into an alternate directory, named by you with the second argument `[dirname]`.

    > i.e Backups will be saved in '~/Documents/mwc-backups/`[dirname]`'.
    >
    > For example:
    >
    > `mwcbackup alt got-new-parts` will backup your saves into '~/Documents/mwc-backups/got-new-parts'.

- `mwcbackup re` will restore your backups from '~/Documents/mwc-backups/mwc-backup'.

    > Before any restorations are performed, the current (active) save files are backed up in:
    >
    > ~/Documents/mwc-backups/restore-backups/
    >
    > The number of restore backups that will be kept can be changed by editing `tmp_limit` near the top of the script.

- `mwcbackup re [dirname]` will restore backups from alternate directory `[dirname]`.

- `mwcbackup rm [dirname]` will remove the backup directory `[dirname]`.

#
