#!/usr/bin/env bash

# steam_lib must point the Steam Library where My Winter Car is installed.
# Either inside Steams default location ~/.local/share/Steam/ or a SteamLibrary.
# If installed into a SteamLibrary, edit 'steam_lib' to point to its location.
steam_lib="$HOME"/.local/share/Steam/

# This is where the back-ups will be saved, ~/Documents/mwc-backups.
backup_loc="$HOME"/Documents/mwc-backups/
# Default backup directory.
backup_dir="mwc-backup"
backup_temp="temp"

# 'saves_path' should be the same for everyone.
saves_path="steamapps/compatdata/4164420/pfx/drive_c/users/steamuser/AppData/LocalLow/Amistech/My Winter Car"

path="$steam_lib""$saves_path"

if [[ ! -d "$path" ]]; then
    echo -e "\e[31merror\e[0m: unable to locate save files, is the path correct?"
    echo -e "lib path: \e[33m$steam_lib\e[0m"
    echo -e "saves path: \e[33m$saves_path\e[0m"
    exit 1
fi

if [[ "$1" == '' ]]; then # If no argument, just do normal back-up.

    if [[ ! -d "$backup_loc""$backup_dir" ]]; then
        mkdir -p "$backup_loc""$backup_dir"
        if [[ "$?" -ne 0 ]]; then
            echo -e "\e[31merror\e[0m: failed to create backup directory"
            exit 1
        fi
    fi

    cp -r "$path/." "$backup_loc""$backup_dir/."

    if [[ "$?" -eq 0 ]]; then
        echo -e "\e[32msuccess\e[0m: saves successfully backed up"
        echo -e "backups located in:\e[33m $backup_loc$backup_dir\e[0m"
    else
        echo -e "\e[31merror\e[0m: saves may not be backed up"
        exit 1
    fi

elif [[ "$1" == 'alt' ]]; then # Save in alternate directory.

    if [[ "$2" == '' ]]; then
        echo -e "\e[31merror\e[0m: missing argument for name of alternate backup directory"
        exit 1
    elif [[ ! -d "$backup_dir""$2" ]]; then
        mkdir -p "$backup_loc""$2"
        if [[ "$?" -ne 0 ]]; then
            echo -e "\e[31merror\e[0m: failed to create backup directory"
            exit 1
        fi
    fi

    cp -r "$path/." "$backup_loc""$2/."

    if [[ "$?" -eq 0 ]]; then
        echo -e "\e[32msuccess\e[0m: saves successfully backed up"
        echo -e "backups located in: \e[33m$backup_loc$2\e[0m"
    else
        echo -e "\e[31merror\e[0m: saves may not be backed up\e[0m"
        exit 1
    fi

elif [[ "$1" == 're' ]]; then # Restore from back-up, overwriting files.

    if [[ ! -d "$backup_loc""$backup_temp" ]]; then # Before restoring, make temp backup of current save files.
        mkdir -p "$backup_loc""$backup_temp"
        if [[ "$?" -ne 0 ]]; then
            echo -e "\e[31merror\e[0m: failed to create temp backup directory"
            exit 1
        fi
    fi

    cp -r "$path/." "$backup_loc""$backup_temp/."

    if [[ "$2" == '' ]]; then # Restore from $backup_dir.
        if [[ ! -d "$backup_loc""$backup_dir" ]]; then
            echo -e "\e[31merror\e[0m: unable to restore, backup directory not found"
            exit 1
        fi

        cp -r "$backup_loc""$backup_dir/." "$path/."
        from="$backup_dir"

    else # If '$2' is not empty, restore from provided alternate directory.
        if [[ ! -d "$backup_loc""$2" ]]; then
            echo -e "\e[31merror\e[0m: unable to restore, backup directory not found"
            exit 1
        fi

        cp -r "$backup_loc""$2/." "$path/."
        from="$2"
    fi

    if [[ "$?" -eq 0 ]]; then
        echo -e "\e[32msuccess\e[0m: backups restored from \e[33m$from\e[0m"
    else
        echo -e "\e[31merror\e[0m: copy failed, backups not restored"
        exit 1
    fi

elif [[ "$1" == 'rm' ]]; then

    if [[ "$2" == '' ]]; then
        echo -e "\e[31merror\e[0m: missing argument for name of backup directory to be removed"
        exit 1
    elif [[ ! -d "$backup_loc""$2" ]]; then
        echo -e "\e[31merror\e[0m: directory not found"
        exit 1
    fi

    rm -r "$backup_loc""$2"

    if [[ "$?" -eq 0 ]]; then
        echo -e "\e[32msuccess\e[0m: removed backup directory \e[33m$2\e[0m"
    else
        echo -e "\e[31merror\e[0m: remove failed"
        exit 1
    fi
else
    echo -e "\e[31merror\e[0m: Unknown argument"
    exit 1
fi
