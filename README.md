# Pipewire Loudness Compensator

## Installation

First, you need to have pipewire installed and setup if you didn't already.

Second, you need to install the following dependencies `git inotify-tools pipewire socat wireplumber`.

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
# To start it at startup if you didn't enable it via the installer
systemctl --user enable pw-loudcompd

# To run it now
systemctl --user start pw-loudcompd
```

## Calibration

You calibrate by adjusting the input gain value in `~/pw-loudcomp/settings.json` or `$XDG_CONFIG_HOME/pw-loudcomp/settings.json` depending on the system. By default, it is set to 0 dB; a higher value will result in a higher bass response AND a higher volume, and vice versa.

The goal is to calibrate your device to a reference (83 dB SPL), which can be complex. You can use an H.A.T.S. or another measurement method, or simply go by feel until it sounds right. If you are an audiophile, you likely know how to measure your headphone/earphone/speaker loudness in dB SPL. If you are not, go by feel; ultimately, you want to enjoy what you listen to.

### A rule of thumb

If you find yourself maxing out your volume, your input gain value should be around positive 0 to 10 dB. Conversely, if your volume for the most part sits around 30–45%, your input gain should be around negative -10 to -20 dB.

If you calibrate your headphones, earphones, or speakers correctly, the volume range should sound the same across all calibrated devices. A 50% volume setting on one device will produce the same loudness as a 50% volume setting on another.
