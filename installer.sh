#!/usr/bin/env bash

set -eu -o pipefail


if [[ "${CLICOLOR_FORCE:-}" -eq 1 ]] || { [[ "${CLICOLOR:-}" -eq 1 ]] && [[ -t 1 ]] }; then
    RESET="\033[0m"; BOLD="\033[1m"; RED="\033[31m"; GREEN="\033[32m"; YELLOW="\033[33m"; BLUE="\033[34m"; MAGENTA="\033[35m"; CYAN="\033[36m"
else
    RESET=""; BOLD=""; RED=""; GREEN=""; YELLOW=""; BLUE=""; MAGENTA=""; CYAN=""
fi


[[ "$EUID" -eq 0 ]] && { printf 'Do %bNOT%b run this script as root.\n' "$RED" "$RESET" >&2; exit 1; }


bin_dir="$HOME/.local/bin"
systemd_user_units_dir="${XDG_CONFIG_HOME:-"$HOME/.config"}/systemd/user"


function _menu() {
    printf 'i) to install pw-loudcomp\nu) to uninstall pw-loudcomp\nq) to quit the instller\n'
    read -r answer
}


function _copy() {
    local filename="${1##*/}"
    local src="${BASH_SOURCE[0]%/*}/${1##*/}"
    local dst="$1"
    local dst_dir="${1%/*}"

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
            [[ ! -d "$bin_dir"                ]] && mkdir -p "$bin_dir"
            [[ ! -d "$systemd_user_units_dir" ]] && mkdir -p "$systemd_user_units_dir"


            _copy "$bin_dir/pw-loudcomp" && chmod +x "$bin_dir/pw-loudcomp"
            _copy "$systemd_user_units_dir/pw-loudcompd.service"
            _copy "$systemd_user_units_dir/pw-loudcomp-socket@.service"
            _copy "$systemd_user_units_dir/pw-loudcomp-socket.socket"


            if ! grep -- "$HOME/.local/bin" <<< "$PATH" >/dev/null; then
                trap "printf '\nOperation cancelled.\n'; exit 0" INT TERM
                printf '%b%s%b not found in %b$PATH%b. Do you want to add it to %b%s%b? [%bY%b/%bn%b] ' "$BLUE" "$bin_dir" "$RESET" "$CYAN" "$RESET" "$MAGENTA" "${SHELL##*/}" "$RESET" "$GREEN" "$RESET" "$RED" "$RESET"
                read answer

                if [[ "$answer" =~ ^[Nn]$ ]]; then
                    printf 'OK.\n'
                else
                    case "${SHELL##*/}" in
                        "sh")
                            shell_filepath="$HOME/.profile"
                            sh -c ". $HOME/.profile"
                        ;;
                        "bash")
                            shell_filepath="$HOME/.bashrc"
                            bash -c "source $HOME/.bashrc"
                        ;;
                        "zsh")
                            shell_filepath="$HOME/.zshrc"
                            zsh -c "source $HOME/.zshrc"
                        ;;
                        "fish")
                            fish -c "fish_add_path $bin_dir"
                        ;;
                        "")
                        ;;
                    esac

                    if [[ -n "${shell_filepath:-}" ]]; then
                        printf '# These two line were added by pw-loudcomp\nexport PATH="$PATH:$HOME/.local/bin"\n' >> "$shell_filepath"
                        $SHELL -c ". "$shell_filepath""
                    fi
                    printf '%b%s%b %badded%b to %b$PATH%b\n' "$BLUE" "$bin_dir" "$RESET" "$GREEN" "$RESET" "$CYAN" "$RESET"
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
            fi

            exit 0
        ;;
        "u")
            systemctl --user is-active pw-loudcompd.service      --quiet 2>/dev/null && systemctl --user stop pw-loudcompd.service
            systemctl --user is-active pw-loudcomp-socket.socket --quiet 2>/dev/null && systemctl --user stop pw-loudcomp-socket.socket

            [[ -e "$systemd_user_units_dir/pw-loudcompd.service"      ]] && systemctl --user disable pw-loudcompd.service
            [[ -e "$systemd_user_units_dir/pw-loudcomp-socket.socket" ]] && systemctl --user disable pw-loudcomp-socket.socket

            _delete "$bin_dir/pw-loudcomp"
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
