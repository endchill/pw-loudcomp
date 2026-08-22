#!/usr/bin/env bash

set -eu -o pipefail


if [[ "${CLICOLOR_FORCE:-}" -eq 1 ]] || { [[ "${CLICOLOR:-}" -eq 1 ]] && [[ -t 1 ]] }; then
    RESET="\033[0m"; BOLD="\033[1m"; RED="\033[31m"; GREEN="\033[32m"; YELLOW="\033[33m"; BLUE="\033[34m"; MAGENTA="\033[35m"; CYAN="\033[36m"
else
    RESET=""; BOLD=""; RED=""; GREEN=""; YELLOW=""; BLUE=""; MAGENTA=""; CYAN=""
fi


[[ "$EUID" -eq 0 ]] && { printf 'Do %bNOT%b run this script as root.\n' "$RED" "$RESET" >&2; exit 1; }


user_bin_dir="$HOME/.local/bin"
systemd_user_units_dir="${XDG_CONFIG_HOME:-"$HOME/.config"}/systemd/user"
man_page_dir="${XDG_DATA_HOME:-"$HOME/.local/share"}/man"


function _menu() {
    printf 'i) to install pw-loudcomp\nu) to uninstall pw-loudcomp\nq) to quit the installer\n'
    read -r answer
}


function _copy() {
    if [[ "$#" -eq 2 ]]; then
        local filename="${1##*/}"
        local src="${BASH_SOURCE[0]%/*}/$2/${1##*/}"
        local dst="$1"
        local dst_dir="${1%/*}"
    else
        local filename="${1##*/}"
        local src="${BASH_SOURCE[0]%/*}/${1##*/}"
        local dst="$1"
        local dst_dir="${1%/*}"
    fi

    if [[ ! -e "$1" ]]; then
        cp "$src" "$dst_dir"
        printf '%bCopied%b %b%s%b to %b%s%b\n' "$GREEN" "$RESET" "$BOLD" "$filename" "$RESET" "$BLUE" "$dst_dir" "$RESET"
    else
        printf '%b%s%b file already exists\n' "$BLUE" "$dst" "$RESET"
        printf 'Do you want to overwrite it? [%by%b\%bN%b] ' "$GREEN" "$RESET" "$RED" "$RESET"
        read -r answer
        if [[ "$answer" =~ ^[Yy]$ ]] ; then
            rm -f "$dst"
            cp "$src" "$dst_dir"
            printf '%bOverwrote%b %b%s%b with %b%s%b\n' "$GREEN" "$RESET" "$BLUE" "$dst" "$RESET" "$BOLD" "$filename" "$RESET"
        fi
    fi
}


function _delete() {
    rm -f "$1"
    printf '%bRemoved%b %b%s%b\n' "$RED" "$RESET" "$BOLD" "$1" "$RESET"
}


trap "printf '\nOperation cancelled.\n'; exit 0" INT TERM


while true; do
    _menu

    case "$answer" in
        "i")
            [[ ! -d "$user_bin_dir"           ]] && mkdir -p "$user_bin_dir"
            [[ ! -d "$man_page_dir/man1"      ]] && mkdir -p "$man_page_dir/man1"
            [[ ! -d "$man_page_dir/man5"      ]] && mkdir -p "$man_page_dir/man5"
            [[ ! -d "$systemd_user_units_dir" ]] && mkdir -p "$systemd_user_units_dir"


            _copy "$user_bin_dir/pw-loudcomp" && chmod +x "$user_bin_dir/pw-loudcomp"
            _copy "$man_page_dir/man1/pw-loudcomp.1" "man_pages"
            _copy "$man_page_dir/man5/pw-loudcomp.5" "man_pages"
            _copy "$systemd_user_units_dir/pw-loudcompd.service" "systemd"
            _copy "$systemd_user_units_dir/pw-loudcomp-socket@.service" "systemd"
            _copy "$systemd_user_units_dir/pw-loudcomp-socket.socket" "systemd"

            mandb --quiet --user-db

            if ! grep -- "$HOME/.local/bin" <<< "$PATH" >/dev/null; then
                trap "printf '\nOperation cancelled.\n'; exit 0" INT TERM
                printf '%b%s%b not found in %b$PATH%b. Do you want to add it to %b%s%b? [%bY%b/%bn%b] ' "$BLUE" "$user_bin_dir" "$RESET" "$CYAN" "$RESET" "$MAGENTA" "${SHELL##*/}" "$RESET" "$GREEN" "$RESET" "$RED" "$RESET"
                read answer

                if [[ "$answer" =~ ^[Nn]$ ]]; then
                    printf 'OK.\n'
                else
                    case "${SHELL##*/}" in
                        "sh")
                            shell_filepath="$HOME/.profile"
                        ;;
                        "bash")
                            shell_filepath="$HOME/.bashrc"
                        ;;
                        "zsh")
                            shell_filepath="$HOME/.zshrc"
                        ;;
                        "fish")
                            shell_filepath="$XDG_CONFIG_HOME/fish/config.fish"
                        ;;
                        "")
                        ;;
                    esac

                    if [[ -n "${shell_filepath:-}" ]]; then
                        if [[ "${SHELL##*/}" == "fish" ]]; then
                            printf '\n# These three lines were added by pw-loudcomp\nset -x PATH "$HOME/.local/bin" $PATH\nset -x MANPATH "$XDG_DATA_HOME/man" $MANPATH\n' >> "$shell_filepath"
                        else
                            printf '\n# These three lines were added by pw-loudcomp\nexport PATH="$HOME/.local/bin:$PATH"\nexport MANPATH="$XDG_DATA_HOME/man:$MANPATH"\n' >> "$shell_filepath"
                        fi
                        $SHELL -c ". "$shell_filepath""
                    fi
                    printf '%b%s%b %badded%b to %b$PATH%b\n' "$BLUE" "$user_bin_dir" "$RESET" "$GREEN" "$RESET" "$CYAN" "$RESET"
                fi
            fi


            printf 'Do you want to %benable%b systemd pw-loudcomp service and socket now? [%bY%b/%bn%b] ' "$BOLD" "$RESET" "$GREEN" "$RESET" "$RED" "$RESET"
            read -r answer

            if [[ "$answer" =~ ^[Nn]$ ]]; then
                printf "OK.\n"
            else
                systemctl --user daemon-reload
                [[ -e "$systemd_user_units_dir/pw-loudcompd.service"      ]] && systemctl --user enable pw-loudcompd.service
                [[ -e "$systemd_user_units_dir/pw-loudcomp-socket.socket" ]] && systemctl --user enable pw-loudcomp-socket.socket
                printf $'Run \'%bsystemctl --user start pw-loudcompd.service%b\' to start pw-loudcomp.\n' "$MAGENTA" "$RESET"
            fi

            exit 0
        ;;
        "u")
            systemctl --user is-active pw-loudcompd.service      --quiet 2>/dev/null && systemctl --user stop pw-loudcompd.service
            systemctl --user is-active pw-loudcomp-socket.socket --quiet 2>/dev/null && systemctl --user stop pw-loudcomp-socket.socket

            [[ -e "$systemd_user_units_dir/pw-loudcompd.service"      ]] && systemctl --user disable pw-loudcompd.service
            [[ -e "$systemd_user_units_dir/pw-loudcomp-socket.socket" ]] && systemctl --user disable pw-loudcomp-socket.socket

            _delete "$user_bin_dir/pw-loudcomp"
            _delete "$man_page_dir/man1/pw-loudcomp.1"
            _delete "$man_page_dir/man5/pw-loudcomp.5"
            _delete "$systemd_user_units_dir/pw-loudcompd.service"
            _delete "$systemd_user_units_dir/pw-loudcomp-socket@.service"
            _delete "$systemd_user_units_dir/pw-loudcomp-socket.socket"

            exit 0
        ;;
        "q")
            printf 'Bye!\n'
            exit 0
        ;;
        "")
            continue
        ;;
        *)
            printf '%b%s%b not found.\n' "$RED" "$answer" "$RESET"
            continue
        ;;
    esac
done
