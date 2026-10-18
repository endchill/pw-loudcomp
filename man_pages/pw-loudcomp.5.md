---
name: pw-loudcomp
section: 5
date: 2026-10-18
---

# NAME

**pw-loudcomp** - settings file for pw-loudcomp

# SYNOPSIS

**$XDG_CONFIG_HOME/pw-loudcomp/settings.env**

# DESCRIPTION

The settings file for **pw-loudcomp**.

# VARIABLES

---

- **input_gain** _integer_ in dB
  Controls the amount of input gain to achieve the listening volume.

- **listening_volume** _integer_ in dB SPL
  The volume level to correct to; it can be set to _almost_ any volume.

- **volume_curve_exponent** _float_
  This setting controls how much the volume changes to feel natural; Windows uses 2, while most Linux slider implementations use 3.

- **processing_mode** _integer_
  0 = FFT; 1 = IIR

- **fft_quality** _integer_
  Controls the buffer size of the FFT algorithm; higher is better quality but with increased processing time. 0 = 256; 1 = 512; 2 = 1024; 3 = 2048; 4 = 4096; 5 = 8192; 6 = 16384

- **iir_approx** _integer_
  Specifies the approximation of the IIR algorithm; higher is better quality but with higher CPU usage. 0 = Fastest; 1 = Low; 2 = Normal; 3 = High; 4 = Best

- **curve** _integer_
  Specifies the curve type. 0 = Flat; 1 = ISO226-2003; 2 = Fletcher-Munson; 3 = Robinson-Dadson; 4 = ISO226-2023

- **is_clipping** _integer_
  Whether to enable/disable clipping.

- **clipping_range** _integer_ in dB
  Specifies a clipping range.

- **output_device** _string_
  Specifies which device to output to. auto = makes the script use the default output device; _device_name_ = uses a specific device

- **output_device_fallback** _string_
  Specifies a fallback device to output to. auto = makes the script use the default output device; _device_name_ = uses a specific device; none = disables fallback

- **system_transfer** _boolean_
  Whether to transfer volume from PipeWire to the plugin and vice versa.

- **system_fallback** _boolean_
  Whether to control volume in PipeWire when the daemon is not running; useful for shortcuts.

- **auto_adjust_volume** _boolean_
  Whether to auto-adjust volume when the input gain changes.

- **auto_reload** _boolean_
  Whether to auto-reload on file save.

- **auto_switch** _boolean_
  Whether to auto-switch devices when the PipeWire default device changes while the daemon is running; only works when **output_device** is set to auto.

- **highest_input_gain_limit** _integer_ in dB
  Sets an upper limit to the input gain; leave empty for no limit.

- **lowest_input_gain_limit** _integer_ in dB
  Sets a lower limit to the input gain; leave empty for no limit.

- **highest_volume_limit** _integer_ in percent
  Sets an upper limit to the volume; leave empty for no limit.

- **lowest_volume_limit** _integer_ in percent
  Sets a lower limit to the volume; leave empty for no limit.

---

# CUSTOM INPUT FOR EACH DEVICE

By adding a variable with the same name as a device name followed by the `_input_gain` suffix, the script will use that input gain instead of the value in **input_gain**.

Note: if the device name contains "." or "-", these characters need to be replaced with "\_" to work.

# SEE ALSO

pw-loudcomp(1)
