# Release 1.7

*June 23rd, 2017*

**This is the 2017 summer release of Mono Framework. It includes major new features along with bug fixes.**

In our effort to streamline the API and make embedded development on Mono easy and fast, we have introduced new C++ classes and augmented existing ones.

In this release note we shall driefly mention all new features in 1.7 and discuss the most important in-depth.

## List of new features and fixes

### New features

This is a major release with many new features, including:

* **Icon system**: A set of predefined icons with symbols like: wifi, temperature, mute, play, pause, etc.
* **Scenes**: A class for grouping UI elements into a _scene_. Then you can navigate between scenes.
* **Battery level** Class for getting the remaining battery power
* **Analog low-pass filter and filtered inputs** Classes for low-pass filtering analog inputs
* **Hysteresis triggers** Class that implements a Schmitt-trigger, for detecting analog values has exceeded a threshold.
* **URL Encoding** A new class can URL encode strings, for use with HTTP GET query parameters
* **Time conversions** The `DateTime` class now builds on top of the standard _libc_  time APIs
* **RingBuffer** Added _mbed's_ circular buffer class. 
* **DHT One wire protocol** We added a class that implements the DHT one wire protocol interface
* **Pin change interrupts** Our interrupt classes now support pin change events. (Rise + Fall events)

### Fixes

This release also fixes a number of bugs, these include:

* Increased the buffer size for _Redpine module's_ receive data buffer
* `PowerSaver` class is more robust when event fire in dimming animation
* Alignment issues in `OnOffButtonView` graphics
* Buzzer API now uses CPU interrupts to end buzzing
* _Major touch input_ fix. Y six was ignored until now. Touch work quite precise now.
* Fixed a graphics bug in incremental repaints of `TextLabelview`
* Touch system does no longer sample input when there is no touch responders
* Fixed bug in queue system, that caused the task queue to become unstable
* RTC wakes does not trigger I/O ports initialization
* Fixed issue that caused `ScheduledTask`'s to wake mono each second

### Deprecated methods

With the new release we are deprecating a couple of redundant methods. Mostly methods with unnecessary verbose names. If you use a deprecated method, use will get a compiler warning.

You should port your code to not use the deprecated methods, since they will be removed in future releases.

## Features in-depth

Let us take a moment to examine some of the most important features and discuss why their are important.

### Icons

We repeatedly found ourselves in need of having icon-decorated push buttons. Also, we again and again needed to display some status info that would be nice to convey in form of small icons.

Therefore we have introduced a monochrome icon bitmap-format, that can be stored in flash memory and displayed in a few lines of code. Further, we added a set of commonly used icons to the framework. These include icons for speaker, wifi, battery, play, pause etc.

You can create your own icons from bitmap images using our free tool [img2icon](https://github.com/getopenmono/img2icon)

#### Example

To use icons are incredibly easy, since we added a `IconView` class to display them on the display:

```cpp
#include <icons/speaker-16.h>

IconView icn(geo::Point(20,20), speaker16);
icn.show();
```

You can also change the coors of icons by using the `setForeground`and `setBackground` methods on `IconView`.

### Scenes

We found we needed at way to switch between different view in applications. Say, the [Alarm Clock](https://kiosk.openmono.com/app/com-openmono-alarmclock) app on MonoKiosk needs to have 3 different scenes to show:

* Normal alarm clock time display (Main Scene)
* Set the time configuration scene (set time scene)
* Set the alarm time scene (set alarm scene)

Each scene takes up the entire display, and we needed to have an easy way to switch between these diferent scenes.

Inspired by what iOS and Andriod uses (*Segues* and *Intents*) we have created a class called `SceneController`. This represents a scene of contents. A scene is logical container of `View`-based objects. You add *views* to a scene. The scene now controls the `show` and `hide` methods for all added views.

This means to can *show * and *hide* all the views in the scene at once, by calling the equivalent methods on the *scene* object. Further, scene implement an interface for implementing transitions between different scenes. This is a enforced structure that makes it easy to to setup and teardown, related to scene changes.

#### Example

To use a scene you simply instanciate it and then add views to it.

```cpp
#include <icons/speaker-16.h>

using mono:ui;
using mono::geo;

SceneController scn;

TextLabelView helloLabel(Rect(0,100,176,20), "Hi, I'm Mono!");
IconView icn(Point(50,100), speaker16);

scn.addView(helloLabel);
scn.addView(icn);

scn.show();
```

### RTC Time integrated with C library functions

Since *Release 1.4.2* we had the RTC time and date tracking enabled. However, the RTC system was integrated only with the highlevel `DateTime` class. Now we have hooked it into the lower level C API's provided by Std. Libc. This means you can use functions like `time` and `localtime`. These alo wotk in conjunction with `DateTime`.

#### Example

```cpp
time_t now = time();
DateTime dtNow(now);
printf("Time and date: %s\r\n", dtNow.toISO8601()());
```

## Critical bug fix

We have also fixed 2 major bugs relating to power consumption in sleep. Due to a bug in the `ScheduledTask` class, Mono consumed too mucg power in sleep mode. Further, the entire I/O (GPIO) system was initialized upon the RTC seconds increments, while in sleep. This introduced even a power consumption overhead.

In 1.7 we have fixed these issues, and achieved low power consumption in sleep mode, as we originally aimed for: 35 µA in sleep mode.

## Download

[Download OpenMono SDK for your platform here](../downloads/index.md)