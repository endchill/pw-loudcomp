---
title: pw-loudcomp
section: 1
date: 2026-08-22
---

# NAME

pw-loudcomp - Loudness compensation for Pipewire

# SYNOPSIS

**pw-loudcomp** \<command\>

# DESCRIPTION

pw-loudcomp is a simple Bash script that automate setting-up, connecting, and adjusting volume of LSP Loudness Compensation.

# COMMANDS

**start-daemon**
:   Starts the daemon if it's not running, recommended to use systemd service instead.

**stop-daemon**
:   Stops the daemon if it's running, recommended to use systemd service instead.

**start-socket**
:   Starts the socket if it's not running, recommended to use systemd socket instead.

**stop-socket**
:   Stops the socket if it's running, recommended to use systemd socket instead.

**reload**
:   Manually reloads config instead of restarting the daemon.

**create-config**
:   Manually creates a config file.

**set-input-gain** \<value\>
:   Sets an input gain value or increases/decreases it.

**set-volume** \<value\>
:   Sets a volume value or increases/decreases it.

**set-mute-state** \<state\>
:   Whether to mute/unmute the output device.

**set-curve-state** \<state\>
:   Whether to enable/disable the correction curve.

**-h**, **--help**
:   Return help message.

**set** \<property\> \<raw_value\>
:   Directly sets values to any LSP loud comp symbol parameter.

# ARGUMENTS

**2(+/-)**
:   Sets an exact value, for set-volume and set-input-gain.

**2%(+/-)**
:   Increases/decreases relative to the value, for set-volume and set-input-gain.

**1/0/toggle**
:   Whether to set a state, for set-mute and set-curve.

# SEE ALSO

**pw-loudcomp**(5)
