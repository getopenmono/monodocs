# Release 1.6

*February 10th, 2017*

**We are happy to announce release 1.6 of the Mono SDK. This release focuses on improvement in the software library, introducing new font and timer systems.**

## New features

Here is a short intro to the the new features of Release 1.6. Later we will discuss some of them in detail, also we strive to write tutorials on the all the new features.

### New proportionally spaced fonts

We have taken the font format from [Adafruits Gfx](https://github.com/adafruit/Adafruit-GFX-Library) library, and made support for it in the text rendering system. This means the [`TextRender`](http://developer.openmono.com/en/latest/reference/mono_display_TextRender.html) class now support the Adafruit *GFXfont* format. The class [`TextLabelView`](http://developer.openmono.com/en/latest/reference/mono_ui_TextLabelView.html) can use the new fonts as well. In fact, the default font face is changed to a beautiful proportionally spaced sans serif type.

We have included all the available font faces from Adafruits library. These include Italic and bold faces of Serif and Sans Serif fonts.

The old mono spaced fonts are still available, but you have to explicitly set them in your code.

### Wake Mono on timers

For a long time we wanted this feature: To sleep mono and then wake up at a specific point in the future. With our new [`ScheduledTask`](http://developer.openmono.com/en/latest/reference/mono_ScheduledTask.html) class, this is possible! A [`ScheduledTask`](http://developer.openmono.com/en/latest/reference/mono_ScheduledTask.html) is a object that calls a function at a given point in time. You provide it with a function pointer and a [`DateTime`](http://developer.openmono.com/en/latest/reference/mono_DateTime.html). This function will then be called at that time, also if Mono are in sleep at that point. (This is opt-in.)

Using [`ScheduledTask`](http://developer.openmono.com/en/latest/reference/mono_ScheduledTask.html) we can create a temperature logger, that sleeps and automatically wakes up periodically to measure the temperature.

### Analog API (mbed)

In this release we finally had the time to implement [`mbed::AnalogIn`](https://developer.mbed.org/handbook/AnalogIn) functionality. This means you can easily use the ADC to measure the voltage on the input pins. Almost all pins on our Cypress PSoC5 MCU can be routed to the ADC, exceptions are the USB pins and the SIO (*Special I/O*) pins. One of these SIO pins are the `J_TIP` pin.

An example of how you read the voltage level on the 3.5mm jack connector's `J_RING1` pin is:

```cpp
mbed::AnalogIn ring1(J_RING1);
float normalizedValue = ring1;
uint16_t rawValue = ring1.read_u16();
```

Thats it! The system take care of setting the right pins mode, and setup the routing of the analog interconnect.

### Power saver

We found ourself keep writing code to auto-sleep mono. Just like smartphone will automatically dim the display and eventually go into standby, to spare the battery. For Mono we wanted it to be opt-in, so you always start a new application project, with a clean slate.

Therefore we have introduced the class [`PowerSaver`](http://developer.openmono.com/en/latest/reference/mono_PowerSaver.html) in 1.6. This class dims the display after a period of inactivity. After even further inactivity, it automatically trigger sleep mode.

Inactivity is no incoming touch events. You can manually ping or momemtarily deactivate the class to keep mono awake. But by default it will trigger sleep mode, if nothing happens to 20 secs.

You should add the [`PowerSaver`](http://developer.openmono.com/en/latest/reference/mono_PowerSaver.html) as a member variable to your [`AppController`](http://developer.openmono.com/en/latest/reference/mono_IApplication.html) class, to enable its functionality.

### More new features

* [`TextLabelView`](http://developer.openmono.com/en/latest/reference/mono_ui_TextLabelView.html) does better text alignment (horizontal and vertical)
* Multiline text in [`TextLabelView`](http://developer.openmono.com/en/latest/reference/mono_ui_TextLabelView.html)
* Callback for Wifi join error handler
* [`DateTime`](http://developer.openmono.com/en/latest/reference/mono_DateTime.html) now support negative numbers in `addTime()` methods
* [`HttpPostClient`](http://developer.openmono.com/en/latest/reference/mono_network_HttpPostClient.html) tries to fix Redpine bug, by appending whitespace to body data.

## Download

* [Windows](http://developer.openmono.com/en/latest/downloads/windows.html)
* [macOS](http://developer.openmono.com/en/latest/downloads/macos.html)
* [Debian/Ubuntu](http://developer.openmono.com/en/latest/downloads/linux.html)

#### Release package hashes

Upon request we have added *sha256* (*sha1* for Windows SDK) hash files for each installer package. In this way you can validate you copy of the installer package against our copy, by comparing hash values.

[Go to the release packages](https://github.com/getopenmono/openmono_package/releases/tag/SDKv1_6)