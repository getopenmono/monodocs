# Release 1.1

*July 20th, 2016*

**Finally, after much work we have a new release of Mono's software library and tool chain.**

The new v1.1 release is available from our [Developer site](http://developer.openmono.com/en/latest/getting-started/install.html). Let me go through the biggest improvements and additions:

#### New default system font

The existing font was pretty old fashioned to put it nicely. We have a new font that takes up a little more room, but it is much better. We have created a bitmap font system, such that we can add more fonts later. If you have used `TextLabelView` (with text size 2), you will instantly take advantage of the new font.

#### Wake-up works (No more resets)

We have fixed the issue that required us to do a reset immediately after wake up. Now mono resumes normal operation after a wake up. Therefore you will not see the `SoftwareResetToApplication` call in *AppController* in your new projects.

If you wish your existing apps to take advantage of this, simply remove the call to `SoftwareResetToApplication `.

#### Sleep while USB is connected

Further, Mono is now able to sleep when connected to the computer. Previously the USB woke up mono when connected. Now you can shut off Mono while the USB is connected.

#### API for the Buzzer

In other news we have added a generic API for the buzz speaker. It is very simple: you define for how long the buzz sound should last. We plan to add frequency tuning in later releases.

#### Signed installer on Windows

We have received a code signing certificate, and used it to sign the installer and the USB Serial Port driver. This means that Windows *should not* yell that much about dangerous, possibly harmful binaries. We still need a certificate for the Mac installer, so Mac users - bear with us.

#### New default colors

The framework defines a set of standard colors for common UI elements, such as: text, borders, highlights and background. Some of these are now changed. Specifically we changed the background color to pitch black, to increment the contrast.

#### Type completion in [Atom](https://atom.io)

Should you choose to use GitHub's excellent [Atom](https://atom.io) code editor, you can now get type completion with documentation. This works much like *Intellisense* in Visual Studio or auto completion in Xcode.

To enable type completion in Atom you need to install [clang](http://clang.llvm.org) on [Windows](http://llvm.org/releases/download.html) and [Linux](http://llvm.org/releases/download.html) systems. Then, you must add the [AutoComplete-Clang](https://atom.io/packages/autocomplete-clang) plugin to Atom. Create a new project with `monomake` and open the project in Atom. Voila!

#### Bug fixes and more

* More accessors in UI Classes (*ButtonView*, *TextLabelView*)
* Default screen brightness is now 100%, instead of 50%
* Less verbose on serial port
* Added PinNames for coming Mono Schematics
* Fixed issue that caused USB not to work after sleep
* *QueueInterrupt* is now setting the correct `snapshot` value
* Fixed issue when color blending 100% opaque or transparent pixels
* Fixed issue that left out a single dot when drawing outlined rectangles

#### Documentation

On *developer.openmono.com* you can now choose between the *latest* documentation (v1.1) and the older *v1.0* version. By default we will show you the *latest* documentation version.