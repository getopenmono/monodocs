# Why use Mono?

***You know, there is flood of Arduino compatible boards out there. Why care about yet another?***
<center><small><em>
yada yada yada... - that's why!
</em></small></center>

## MCU's speak by timing changes of charge

I love getting a new development board! You might remember getting your first Arduino board and hooking it up to your computer. Then writing:

```cpp

	int ledPin = 13;
	void setup()
	{
		pinMode(ledPin, OUTPUT);
	}
	void loop()
	{
		digitalWrite(ledPin, HIGH);
		delay(1000);
		digitalWrite(ledPin, LOW);
		delay(1000);
	}
```

Yeah, a slow blinking LED! Arduino were the first to make getting started on programming embedded devices, extremely simple and easy.

But as the initial enthusiasm wears off, you begin wondering how you build an automatic tweet button, a [Philips Hue](http://meethue.com) light control switch or some integration with your [Nest](https://nest.com) thermostat? I realized I needed a way of communicating with my Arduino, because I do not speak SPI nor UART - my computer do - but I do not <i class="fa fa-smile-o"></i>.

### A build-in Display

To enable easy communication with humans, we need to attach a display shield to our Arduino. Have you tried doing that? First check the voltage levels fits, then there is the SPI or parallel interface to the diaplay controller chip, finally we use Adafrait's displays library to draw some simple shaped on the screen. That was my weekend - half fun, half frustrating!

*Mono comes with a touch display built-in, and includes display drivers along with a sophisticated UI Widget and touch event system.*

### Build-in Wireless

OK, are we now ready to do some real things with a Arduino and display shield? It depends, because what I really would like to controlling my Hue lights using [Philips Hue API](http://www.developers.meethue.com), which is JSON based Web API. So I buy a Wifi shield to attach to my Arduino.

Now, I already have a display shield attached - but luckily it fits together after only rewiring the SPI and CS signals, along with some re-fitting of the voltage supply lines.

