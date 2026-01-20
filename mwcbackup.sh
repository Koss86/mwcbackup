#!/usr/bin/env bash

# steam_lib must point the Steam Library where My Winter Car is installed.
# Either inside Steams default location ~/.local/share/Steam/ or a SteamLibrary.
# If installed into a SteamLibrary, edit 'steam_lib' to point to its location.
steam_lib="$HOME"/.local/share/Steam/

# 'mwc_saves' should be the same for everyone.
mwc_saves="steamapps/compatdata/4164420/pfx/drive_c/users/steamuser/AppData/LocalLow/Amistech/My Winter Car"

# This is where the back-ups will be saved, ~/Documents/mwc-backups.
backup_loc="$HOME"/Documents/mwc-backups/

# Name for default backup directory.
backup_dir="mwc-backup"

# Name for directory where restore-backups will be located.
tmp_dir="restore-backups/"

tmp_path="$backup_loc""$tmp_dir"

# Prefix for restore-backup directories.
tmp_prefix="mwc-save"

# Number of restore-backups to keep.
tmp_limit=5

path="$steam_lib""${mwc_saves}"

if [[ ! -d "${path}" ]]; then
    echo -e "\e[31merror\e[0m: unable to locate save files, is the path correct?"
    echo -e "lib path: \e[33m$steam_lib\e[0m"
    echo -e "saves path: \e[33m${mwc_saves}\e[0m"
    exit 1
fi

if [[ -z "$1" ]]; then # If no argument, just do normal back-up.

    if [[ ! -d "$backup_loc""$backup_dir" ]]; then
        mkdir -p "$backup_loc""$backup_dir"
        if [[ "$?" -ne 0 ]]; then
            echo -e "\e[31merror\e[0m: failed to create backup directory"
            exit 1
        fi
    fi

    cp -r "${path}/." "$backup_loc""$backup_dir/."

    if [[ "$?" -eq 0 ]]; then
        echo -e "\e[32msuccess\e[0m: saves successfully backed up"
        echo -e "backups located in:\e[33m $backup_loc$backup_dir\e[0m"
    else
        echo -e "\e[31merror\e[0m: saves may not be backed up"
        exit 1
    fi

elif [[ "$1" == 'alt' ]]; then # Save in alternate directory.

    if [[ -z "$2" ]]; then
        echo -e "\e[31merror\e[0m: missing argument for name of alternate backup directory"
        exit 1
    elif [[ ! -d "$backup_dir""$2" ]]; then
        mkdir -p "$backup_loc""$2"
        if [[ "$?" -ne 0 ]]; then
            echo -e "\e[31merror\e[0m: failed to create backup directory"
            exit 1
        fi
    fi

    cp -r "${path}/." "$backup_loc""$2/."

    if [[ "$?" -eq 0 ]]; then
        echo -e "\e[32msuccess\e[0m: saves successfully backed up"
        echo -e "backups located in: \e[33m$backup_loc$2\e[0m"
    else
        echo -e "\e[31merror\e[0m: saves may not be backed up\e[0m"
        exit 1
    fi

elif [[ "$1" == 're' ]]; then # Restore from back-up, overwriting files.

    if [[ -z "$2" ]]; then # Restore from $backup_dir.
        if [[ ! -d "$backup_loc""$backup_dir" ]]; then
            echo -e "\e[31merror\e[0m: unable to restore, backup directory not found"
            exit 1
        fi
        from="$backup_dir"

    else # If '$2' is not empty, restore from provided alternate directory.
        if [[ ! -d "$backup_loc""$2" ]]; then
            echo -e "\e[31merror\e[0m: unable to restore, backup directory not found"
            exit 1
        fi
        from="$2"
    fi

    # create a restore-backup
    timestamp="$(date +%m-%d)"-"$(date +%s)"
    tmp_save_dir="$tmp_prefix"-"$timestamp"
    if [[ ! -d "$tmp_path""$tmp_save_dir" ]]; then
        mkdir -p "$tmp_path""$tmp_save_dir"
    fi
    cp -r "${path}/." "$tmp_path""$tmp_save_dir/."

    # restore from backup
    cp -r "$backup_loc""$from/." "${path}/."
    res_success=$?

    # remove oldest restore-backup
    num_of_tmps="$(ls $tmp_path | grep $tmp_prefix | wc -l)"
    if [[ "$num_of_tmps" -gt "$tmp_limit" ]]; then
        while [[ "$num_of_tmps" -ne "$tmp_limit" ]]; do
            oldest_dir=$(find "$tmp_path" -maxdepth 1 -type d -name "$tmp_prefix*" | sort | head -n 1)
            if [[ "$?" -eq 0 ]]; then
                rm -r "$oldest_dir"
                ((--num_of_tmps))
            else
                break
            fi
        done
    fi

    if [[ "$res_success" -eq 0 ]]; then
        echo -e "\e[32msuccess\e[0m: backups restored from \e[33m$from\e[0m"
    else
        echo -e "\e[31merror\e[0m: copy failed, backups not restored"
        exit 1
    fi

elif [[ "$1" == 'rm' ]]; then

    if [[ -z "$2" ]]; then
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
