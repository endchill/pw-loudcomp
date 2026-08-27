---
title: pw-loudcomp
section: 1
date: 2026-08-22
---

# NAME

pw-loudcomp - Loudness compensation for PipeWire

# SYNOPSIS

**pw-loudcomp** \<command\>

# DESCRIPTION

pw-loudcomp is a simple Bash script that automates setting up, connecting, and adjusting the volume of LSP Loudness Compensation.

# COMMANDS

**start-daemon**
:   Starts the daemon if it is not running; it is recommended to use the systemd service instead.

**stop-daemon**
:   Stops the daemon if it is running; it is recommended to use the systemd service instead.

**start-socket**
:   Starts the socket if it is not running; it is recommended to use the systemd socket instead.

**stop-socket**
:   Stops the socket if it is running; it is recommended to use the systemd socket instead.

**reload**
:   Manually reloads the configuration instead of restarting the daemon.

**create-config**
:   Manually creates a configuration file.

**set-input-gain** \<value\>
:   Sets an input gain value or increases or decreases it.

**set-volume** \<value\>
:   Sets a volume value or increases or decreases it.

**set-mute-state** \<state\>
:   Specifies whether to mute or unmute the output device.

**set-curve-state** \<state\>
:   Specifies whether to enable or disable the correction curve.

**-h**, **--help**
:   Displays the help message.

**set** \<property\> \<raw_value\>
:   Directly sets values for any LSP loudness compensation symbol parameter.

# ARGUMENTS

**2(+/-)**
:   Sets an exact value for set-volume and set-input-gain.

**2%(+/-)**
:   Increases or decreases the value relatively for set-volume and set-input-gain.

**1/0/toggle**
:   Sets a state for set-mute-state and set-curve-state.

# SEE ALSO

**pw-loudcomp**(5)
