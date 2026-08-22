---
title: pw-loudcomp
section: 5
date: 2026-08-22
---

# NAME

pw-loudcomp - settings file for pw-loudcomp

# SYNOPSIS

**$XDG_CONFIG_HOME/pw-loudcomp/settings.env**

# DESCRIPTION

The settings file of pw-loudcomp.

# VARIABLES

**input_gain** \<integer\> in dB
:   Controls the amount of input gain to achieve listening volume.

**listening_volume** \<integer\> in dB SPL
:   The volume level when correcting too, it can be set to _almost_ any volume.

**processing_mode** \<integer\>
:   0 = FFT
:   1 = IIR

**fft_quality** \<integer\>
:   Controls the buffer size of the fft algorithm, higher is better quality, but with longer in processing time.
:   0 = 256\
:   1 = 512\
:   2 = 1024\
:   3 = 2048\
:   4 = 4096\
:   5 = 8192\
:   6 = 16384

**iir_approx** \<integer\>
:   Specifies the approximation of the IIR algorithm, higher is better quality, but with higher CPU usage.\
:   0 = Fastest\
:   1 = Low\
:   2 = Normal\
:   3 = High\
:   4 = Best

**curve** \<integer\>
:   Specify the curve type.\
:   0 = Flat\
:   1 = ISO226-2003\
:   2 = Fletcher-Munson\
:   3 = Robinson-Dadson\
:   4 = ISO226-2023

**is_clipping** \<integer\>
:   Whether to enable/disable clipping.

**clipping_range** \<integer\> in dB
:   Specify a clipping range.

**output_device** \<string\>
:   Specify which device to output to.\
:   auto \ \ \ \ \ \ \ \ \ = make the script use the default output device\
:   \<device_name\> = use a specific device

**output_device_fallback** \<string\>
:   Specify a fallback device to output to.\
:   auto \ \ \ \ \ \ \ \ \ = make the script use the default output device.\
:   \<device_name\> = use a specific device\
:   none \ \ \ \ \ \ \ \ \ = disable fallback

**system_transfer** \<boolean\>
:   Whether to transfer volume from pipewire to plugin and vice versa.

**system_fallback** \<boolean\>
:   Whether to control in pipewire when the daemon is not running, useful for shortcuts.

**auto_adjust_volume** \<boolean\>
:   Whether to auto adjust volume when input gain change.

**auto_reload** \<boolean\>
:   Whether to auto reload on file save.

**auto_switch** \<boolean\>
:   Whether to auto switch devices when pipewire default device changes while the daemon is running, only works when output_device is auto.

**highest_input_gain_limit** \<integer\> in dB
:   Sets an upper limit to input gain, empty for no limit.

**lowest_input_gain_limit** \<integer\> in dB
:   Sets a lower limit to input gain, empty for no limit.

**highest_volume_limit** \<integer\> in percentage
:   Sets an upper limit to volume, empty for no limit.

**lowest_volume_limit** \<integer\> in percentage
:   Sets a lower limit to volume, empty for no limit.

# CUSTOM INPUT FOR EACH DEVICE

By adding a variable with the same name as an device name follow with _input_gain suffix the script will use that input gain instead of using the value in **input_gain**\
Note: if the device name contain "." or "-" they need to be replaced with "\_" to work.

# SEE ALSO

**pw-loudcomp(1)**
