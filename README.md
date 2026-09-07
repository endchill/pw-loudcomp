# Pipewire Loudness Compensator

## Installation

First, You need to have pipewire installed and setup if you didn't already.

Second, you need to install some these `git inotify-tools jq pipewire pipewire-pulse socat wireplumber`.

```sh
# For Debian/Ubuntu based distros
apt install git inotify-tools jq pipewire pipewire-pulse socat wireplumber

# For Fedora based distros
dnf install git inotify-tools jq pipewire pipewire-pulse socat wireplumber

# For Arch based distros
pacman -S --needed git inotify-tools jq pipewire pipewire-pulse socat wireplumber
```

Third, clone the repo and run the installer.

```sh
git clone https://github.com/endchill/pw-loudcomp
./pw-loudcomp/installer.sh
```

## Quick Start

After installing pw-loudcomp you can either start via `pw-loudcomp start-daemon` in a terminal or by using systemd user service

```sh
# To enable it if you didn't enable it via the installer
systemctl --user enable pw-loudcompd

# To run it now
systemctl --user start pw-loudcompd
```

## Calibration

If you don't know how to measure, don't have the tools, and you don't want the most accurate setup, either 

**Recommended**: Go with feel and what sounds good, if you just want to enjoy listening to music.

**More accurate**: You can try measuring it using your phone via [NIOSH Sound Level Meter](https://apps.apple.com/sa/app/niosh-sound-level-meter/id1096545820) on IOS, [Decibel X](https://play.google.com/store/apps/details?id=com.skypaw.decibel) on Android, or any application that measures C-Weighted loudness.

* For Speakers, play `pink_noise_-20_dbfs.wav` at max volume, position your phone microphone facing the speaker at listening position and adjust the volume until it reaches your listenning volume (default 83 dB SPL), then repeat for each speaker.
* For Headphones, play `pink_noise_-20_dbfs.wav` at max volume, position your phone microphone facing the driver about the distance between the driver and your ear, then adjust the `input_gain` until it reaches your listenning volume (default 83 dB SPL), then repeat for each driver.
* For IEMs/Earphones you can't calibrate it using any microphone you need a HATS, so do **_the way_**, or stick to what's sounds good.

**_The way_**: If your an audiophile and have the tools you're probably already know how to calibrate it, using Head and Torso Simulators (HATS) to measure the loudness, using in-ear microphones for headphones, or a Decibel Meter for a pair of speakers.
