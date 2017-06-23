# Release 1.3

*October 18th, 2016*

**We have discovered some annoying bugs in version 1.2 and therefore we have released version 1.3 that resolves many issues.**

SDK 1.3 adds no new features, it is a purely bug fix release.

#### Fixes Serial port reset bug

Many users have experienced that the `make install` did not work properly. They always needed to do a *force bootloader* reset manually, before being able to upload new apps to mono.

The issue was that the serial DTR signal did not trigger a reset on Mono. This has been resolved in 1.3, and `make install` works like it should.

#### I2C functionality restored

A linking error in 1.2 broke the I2C communication. This meant the temperature and accelerometer could not be used. This is fixed in 1.3

#### No more spontaneous wake ups

An issue with false-positive interrupts from the Wireless and Display chips while in sleep is resolved. Now sleep mode disables interrupts from there components, this means they cannot wake Mono.

When in sleep mode, the power supply (3V3 net) for all peripherals is turned off - to preserve battery. But capacity on the power net means that the voltage stays high and slowly falls towards zero. This triggered random behaviour in the IC's causing flicker on the interrupt signals.

If you had issues with Mono waking up approximately 8-10 secs after going to sleep, the fix will resolve this issue.

#### HTTPClient parsed port number incorrectly

The feature added in 1.2 allowed the class HTTPClient to handle URL's like: `http://mydomain.com:8080/hello`. But a bug in the overloaded assignment operator, caused the port number to be lost during assignment. This effectively broke support for port numbers.

This issue have been resolved in 1.3

#### Structural change in libraries

The SDK has until now consisted to code from 4 distinct repositories:

* mono_psoc5_library
* mbedComp
* mbed
* mono_framework

Starting with 1.3 we have merged all these into *mono_framework*, since the other 3 were used only by *mono_framework*. This simplifies the building process of the library, hopefully reducing the number of bugs.

On a side note, @jp is working to setup *continous integration* tests for the repositories.

### Download

* [macOS](https://github.com/getopenmono/openmono_package/releases/download/SDKv1_3/OpenMono-v1.3-Mac.pkg)
* [Windows](https://github.com/getopenmono/openmono_package/releases/download/SDKv1_3/OpenMonoSetup-v1.3.0.exe)
* [Linux](https://github.com/getopenmono/openmono_package/releases/tag/SDKv1_3) (Debian based distorts)