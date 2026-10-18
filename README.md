# Pipewire Loudness Compensator

## Introduction

pw-loudcomp is a user-space PipeWire script for loudness compensation, with a CLI, settings, persistent state, JSON IPC socket, hot reloadable, systemd integration, with some DE/Compositors integration, implemented in Bash with few dependencies.

You can also just copy the main script (pw-loudcomp) and run it, but it's recommended to use the installer.

## Installation

First, you need to have pipewire installed and setup if you didn't already.

Second, you need to install the following dependencies.

```sh
# For Debian/Ubuntu based distros
apt install awk grep git inotify-tools lsp-plugins-lv2 pipewire pipewire-bin socat wireplumber jq

# For Fedora based distros
dnf install awk grep git inotify-tools lsp-plugins-lv2 pipewire pipewire-utils socat wireplumber jq

# For Arch based distros
pacman -S --needed awk grep git inotify-tools lsp-plugins-lv2 pipewire socat wireplumber jq
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

It's highly recommended to configure the settings, and integrated it with your DE/Compositor using the JSON IPC Socket, unless you use KDE Plasma, pw-loudcomp supports KDE Plasma by default.

## Enabling Color

Enabling color can be achieved by setting **CLICOLOR** or **CLICOLOR_FORCE** to 1.

## IPC Socket

The IPC socket file lives in `/run/user/<UID>/pw-loudcomp/state.sock` or `$XDG_RUNTIME_DIR/pw-loudcomp/state.sock` and it returns JSON data so you can integrated it easyly in Waybar or Quickshell.

Also you can use `/run/user/<UID>/pw-loudcomp/pw-loudcomp.lock` or `$XDG_RUNTIME_DIR/pw-loudcomp/pw-loudcomp.lock` to check if pw-loudcomp is running or not, and it contain the pid of the pw-loudcomp process.

When a program connects to the socket, the socket will send the state for all connected sockets.

All keys values are type integer.

| **Key**               | **Description**                                |
|-----------------------|------------------------------------------------|
| outputID              | ID of the active output device                 |
| inputGain             | current input gain                             |
| volume                | Current output volume                          |
| muteState             | Whether the output is muted                    |
| curveState            | Active curve                                   |
| listeningVolume       | The reference volume used for the compensation |
| highestInputGainLimit | Upper limit for input gain                     |
| lowestInputGainLimit  | Lower limit for input gain                     |
| highestVolumeLimit    | Upper limit for volume                         |
| lowestVolumeLimit     | Lower limit for volume                         |

## Calibration

You calibrate by adjusting the input gain value in `~/pw-loudcomp/settings.env` or `$XDG_CONFIG_HOME/pw-loudcomp/settings.env` depending on the system. By default, it is set to 0 dB; a higher value will result in a higher bass response **AND** a higher volume, and vice versa.

The goal is to calibrate your device to a reference (83 dB SPL), which can be complex. You can use an H.A.T.S. or another measurement method, or simply go by feel until it sounds right. If you are an audiophile, you likely know how to measure your headphone/earphone/speaker loudness in dB SPL. If you are not, go by feel; ultimately, you want to enjoy what you listen to.

### A rule of thumb

If you find yourself maxing out your volume, your input gain value should be around positive 0 to 10 dB. Conversely, if your volume for the most part sits around 30–45%, your input gain should be around negative -10 to -20 dB.

If you calibrate your headphones, earphones, or speakers correctly, the volume range should sound the same across all calibrated devices. A 50% volume setting on one device will produce the same loudness as a 50% volume setting on another.
