# Datasheets

**If you need to dive a little deeper into the inner workings of Mono, we have collected the datasheets for the components in Mono**

You might need consult specific datasheets for the components in Mono, if you are debugging or just need some advanced features not provided by the API.

## Accelerometer

Mono's accelerometer is a *MMA8652FC* chip by Freescale. It is connected to Mono's I<sup>2</sup>C bus.

<table class="table wy-text-center">
	<tr>
		<td><img src="https://github.com/getopenmono/monodocs/raw/master/datasheets/accelerometer.png" alt="MMA8652FC Accelerometer datasheet thumbnail" title="MMA8652FC Accelerometer datasheet" /></td>
	</tr>
	<tr>
		<td><a href="https://github.com/getopenmono/monodocs/raw/master/datasheets/MMA8652FC.pdf" class="btn btn-neutral"><span class="fa fa-download">Download PDF</span></a></td>
	</tr>
</table>

The accelerometer is handled by the [`MonoAccelerometer`](//github.com/getopenmono/mono_framework/blob/master/src/mono_accelerometer.h) class in the software framework. If you need specific features, or just wish to play with the component directly, you should consult the datasheet.

## MCU

Mono's Micro Controller Unit (MCU) is a Cypress PSoC5LP, that is an Arm Cortex-M3 CPU. You can use all its registers and functions for your application, the SDK includes headers for all pins and registers. (You must explicitly include the `project.h` file.)

The MCU model we use has 64 Kb SRAM, 256 Kb Flash RAM and runs at 66 Mhz.

<table class="table wy-text-center">
	<tr>
		<td>
		<img src="https://github.com/getopenmono/monodocs/raw/master/datasheets/psoc5.png" alt="Cypress PSoC5 Technical Reference Manual thumbnail" title="Cypress PSoC5 Technical Reference Manual" />
		</td>
	</tr>
	<tr>
		<td><a href="http://www.cypress.com/file/123561/download" class="btn btn-neutral"><span class="fa fa-download">Download PDF</span></a></td>
	</tr>
</table>

The software framework encapsulates most MCU features in the *mbed* layer, such as GPIO, interrupts and timers. Also power modes is controlled by the registers in the MCU and utilized insode the [`PowerManagement`](//github.com/getopenmono/mono_framework/blob/master/src/mono_power_management.h) class.

## Display Chip

The display is driven by an *ILITEK 9225G* chip. On mono we have hardwired the interface to 16 bit 5-6-5 color space and the data transfer to be 9-bit dedicated SPI, where the 9th bit selects data/command registers. (This should make sense, when you study the datasheet.)

<table class="table wy-text-center">
	<tr>
		<td><img src="https://github.com/getopenmono/monodocs/raw/master/datasheets/display.png" alt="Ilitek 9225G display driver specification thumbnail" title="Ilitek 9225G display driver specification" /></td>
	</tr>
	<tr>
		<td><a href="https://github.com/getopenmono/monodocs/raw/master/datasheets/ILI9225G_DS_V0_06_20110228.pdf" class="btn btn-neutral"><span class="fa fa-download">Download PDF</span></a></td>
	</tr>
</table>

In the framework the display controller class [`ILI9225G`](https://github.com/getopenmono/mono_framework/blob/master/src/display/ili9225g/ili9225g.h) utilizes the communication and pixel blitting to the display chip. 

## Wireless

Mono uses the Redpine Wifi chip to achieve wireless communication. (The redpine includes Bluetooth for the Maker model, also.) The chip is connect via a dedicated SPI interface, and has a interrupt line connected as well.

<table class="table wy-text-center">
	<tr>
		<td><img src="https://github.com/getopenmono/monodocs/raw/master/datasheets/redpine.png" alt="Redpine WiseConnect Software Programming Reference Manual thumbnail" title="Redpine WiseConnect Software Programming Reference Manual" /></td>
	</tr>
	<tr>
		<td><a href="https://github.com/getopenmono/monodocs/raw/master/datasheets/RS9113-WiseConnect-Software-PRM-v1.5.0.pdf" class="btn btn-neutral"><span class="fa fa-download">Download PDF</span></a></td>
	</tr>
</table>

The communication interface is quite advanced, including many data package layers. You can find our implementation of the communication in the [`ModuleSPICommunication`](https://github.com/getopenmono/mono_framework/blob/master/src/wireless/module_communication.h#L275) class. This class utilizes the SPI communication from and to the module, it does not know anything about the semantics of the commands sent.

## Temperature Sensor

The temperature sensor is an Amtel *AT30TS74* chip, connected via the internal I<sup>2</sup>C bus.

<table class="table wy-text-center">
	<tr>
		<td><img src="https://github.com/getopenmono/monodocs/raw/master/datasheets/temperature-sensor.png" alt="Redpine WiseConnect Software Programming Reference Manual thumbnail" title="Redpine WiseConnect Software Programming Reference Manual" /></td>
	</tr>
	<tr>
		<td><a href="https://github.com/getopenmono/monodocs/raw/master/datasheets/Atmel-8897-DTS-AT30TS74-Datasheet.pdf" class="btn btn-neutral"><span class="fa fa-download">Download PDF</span></a></td>
	</tr>
</table>

The temperature interface is used in the [`AT30TS74Temperature`](https://github.com/getopenmono/mono_framework/blob/master/src/at30ts74_temperature.h) class.