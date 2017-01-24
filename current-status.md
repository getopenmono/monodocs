# Current Frameowrk Status

**Mono Framework is a continuous process. We prioritize the crucial components of the framework, and keep the some functionalities in the pipeline.**

_Also see the [API Reference](reference/reference.md)_

Here is a list of the components and their implementation, sorted by category:

#### Core Classes

* **String**: Fully implemented (lightweight)
* **Timer**: Fully implemented
* **Managed Pointer**: fully implemented
* **Queue**: Fully implemented
* **Regex**: Fully implemented
* **QueuedInterrupt**: Fully implemented (with debouncing)
* **stdio.h**: fully implemented (powered by mbed).
* **DateTime**: Fully functional - but does linear time calcs.
* **PowerSaver**: First revision

#### Core Application

* **ApplicationContext**: Fully implemented, but changes might occur.
* **ApplicationController**: Interface is fully defined
* **Application Run Loop**: Fully implemented
* * **Run Loop Task**: Interface fully defined
* **RTC System Interface**: Fully implemented

#### Power Management

* **Power Aware Interface**: Fully implemented
* **Power Management**: Partially implemented
* **Power Subsystem**: Partially implemented

#### Inputs

* **Accelerometer**: Sparsely implemented
* **Temperature**: Sparsely implemented
* **Touch System**: Fully implemented
	* **Touch Responder**: Fully implemented
 	* **Touch Event**: Fully implemented
* **USB Serial I/O**: Partially implemented
 
#### Display System

* **Color**: Fully implemented
* **DisplayController**: Fully functional, need optimizations
* **DisplayPainter**: Fully functional, needs optimizations.
* **TextRender**: Mostly implemented

##### UI Classes

* **View**: Fully implemented
* **ButtonView**: Partially implemented - needs subclasses for different button types
* **ConsoleView**: Fully implemented
* **ImageView**: Fully implemented
* **ProgressbarView**: Fully implemented
* **ResponderView**: Fully implemented
* **StatusIndicatorView**: Fully implemented
* **TextLabelView**: Fully implemented, but needs support for line breaks
* **TouchCalibrator**: Fully implemented

All UI classes might still need some visual design improvements.

#### Geometric Shapes (for graphics)

* **Rectangle**: Fully implemented
* **Circle**: Fully implemented
* **Point**: Fully implemented
* **Size**: Fully implemented

#### Wifi & Networking

* *Easy Wifi configuration*: not implemented yet
* *Network and Communication with Redpine hardware*: Partially implemented
* **Network Requests**: Partially implemented
	* **DnsResolution**: Fully implemented
	* **HttpClient**: Preliminary implementation. Needs to be implemented using raw socket, not Redpine's API.

#### Bluetooth

* **Hardware communication**: not yet implemented

*At this point no Bluetooth specific code exist. The bluetooth hardware is present, and the basic communication is implemented in the wireless libraries. Until we add bluetooth code to the framework, you must use Redpine own documentation.*

#### Media

* **BMP Image format support**: Partial implemented (only 5-6-5 RGB images supported)

### Lower level APIs?

If you wonder where stuff like file I/O, SPI, I2C and serial communication are, then rest assured that it exists. All these APIs are not a part of mono framework, but included in [mbed](https://developer.mbed.org/).

#### mbed includes:

* I2C
* SPI
* Serial (UART)
* H/W Interrupts
* H/W Timers
* PWM
* SD Card I/O
* File I/O
* GPIO
* Analog I/O
 
 See **[mbed documentation here](https://developer.mbed.org/handbook/Homepage)**
