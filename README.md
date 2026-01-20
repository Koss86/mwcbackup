# My Winter Car Back-up

A bash script for Linux users to back up My Winter Car save files.

## Setup

#### Install Location

If you installed MWC into the default location `~/.local/share/Steam` then you don't need to do anything.

But, if you installed MWC into a Steam Library you will need to edit `steam_lib` at the top of `mwcbackup.sh` to point to the Library's location.

For example:

On my dekstop, MWC is installed in a Steam Library located at `/mnt/ssd-1tb/SteamLibrary/`.

So my `steam_lib` for my dekstop must be `steam_lib="/mnt/ssd-1tb/SteamLibrary/"`.

## Usage

#### Alias

If you're in the same directory as the script, you can simply type `./mwcbackup.sh` in your terminal to run it.

But a better way is to create an alias in your .bashrc file. Which is usually located at ~/.bashrc.

To create an alias copy and paste the snippet below into your .bashrc.

```sh
# Replace 'path/to' with acutal path.
alias mwcbackup='path/to/mwcbackup.sh'

```

Replace `path/to` with the path to mwcbackup.sh on your system, then save and restart your terminal.

Now mwcbackup.sh can be ran from anywhere by typing `mwcbackup` as if it was in your $PATH.

#

#### Path

Another method you can use is copying `mwcbackup.sh` into a directory that is in your $PATH

Use the command `echo $PATH` to see directories that are in your $PATH.

Once the script is in your $PATH, you can run the script from anywhere by typing `mwcbackup.sh` in your terminal.

#

#### Commands

Once an alias is setup or mwcbackup.sh is in your $PATH, use these commands in your termainal to back up, restore, or remove your backed up saves.

If you are using the Path method, use `mwcbackup.sh` below, instead of `mwcbackup`.

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
