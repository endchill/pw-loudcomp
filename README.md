# Pipewire Loudness Compensator

## Installation

First, You need to have pipewire installed and setup if you didn't already.

Second, you need to install some these `git inotify-tools pipewire socat wireplumber`.

```sh
# For Debian/Ubuntu based distros
apt install git inotify-tools pipewire socat wireplumber

# For Fedora based distros
dnf install git inotify-tools pipewire socat wireplumber

# For Arch based distros
pacman -S --needed git inotify-tools pipewire socat wireplumber
```

Third, clone the repo and run the installer.

```sh
git clone https://github.com/endchill/pw-loudcomp
./pw-loudcomp/installer.sh
```

## Quick Start

After installing pw-loudcomp you can either start via `pw-loudcomp start-daemon` in a terminal or by using systemd user service

```sh
# To enable it if you didn't enable it via the installer already
systemctl --user enable pw-loudcompd

# To run it now
systemctl --user start pw-loudcompd
```

## Calibration

Calibration... is complicated, either use an H.A.T.S or something similar it's or go by feel, if your an audiophile you probably know how to measure your headphone, earphone, or speakers, and if your not an audiophile go by feel, in the end you're going to enjoy what you'll listen to.
