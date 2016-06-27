# Measuring the Temperature

**This quick tutorial will demonstrate how you measure the temperature, by using the standard temperature sensor API**

Mono has a built-in thermometer that is situated on the PCB under the SD Card connector. We have a standard API for getting the temperature in degrees Celcius. If you wish to get convert to Fahrenheit, use this formula: \\\( ^{\circ}F = ^{\circ}C \cdot 1.8 + 32 \\\)

## Temperature measuring Caveats

Measuring the temperature seems like a simple operation, but you should know that it is actually quite difficult to get it right. First for all, unless you really invert money and time advanced equipment and in calibrating this equipment, then you will not get a precise measurement. But then, what is a precise measurement?

First lets visit the terms: absolute and relative measurements. An absolute temperature measurement is a temperature measured againts a fixed global reference. At the summer the sea temperature at the beaches reach \\\(25 ^{\circ}C\\\) or \\\(77 ^{\circ}F\\\). This is an absolute measurement. In contrast if I say: The sea temperature has rised by \\\(2 ^{\circ}C\\\) or \\\(3,5 ^{\circ}F\\\), rise in temperature is a reltive measurement.

When measuring temperature you should know that absolute measurements are hard, and relative measurements are easy in comparison. Normal household thermometers do not achieve a precision below \\\(1 ^{\circ}C\\\) or \\\(1.8 ^{\circ}F\\\), in absolute measurements. But their relative precision can be far better - like \\\(0.1 ^{\circ}C\\\) or \\\(0.18 ^{\circ}F\\\).

Mono's built-in thermometer share the same characteristics. However, be aware the thermometer is mounted on the PCB which get heated by the CPU and battery. You are measuring the temperature of the PCB - not the air temperature. To overcome this you can put mno in sleep mode for some time, and then wake up and measure the temperature. When Mono is in sleep, the PCB will (over time) get the same temperature as the air around it.

## Example

Well, enough of that! Let us try to fetch the temperature! The Mono SDK uses a standard interface for getting the temperature, that abstracts away the hardware. The interface contains of only two functions:

* `Read()` To get the temperature in celcius (as an integer)
* `ReadMilliCelcius()` To get the temperature in an integer that is 1000th of a celcius. \\\(1 ^{\circ}C = 1000 ^{\circ}mC\\\)