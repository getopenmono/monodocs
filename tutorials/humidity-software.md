# Humidity app

In the [first part](humidity-hardware.md) of this Humidity app tutorial, I showed how to connect a humidity sensor to Mono.  Now, I will show how to get and display humidity and temperature readings.

## Displaying readings

The humidity sensor measures both humidity and temperature, and I want these readings shown in a nice big font and funky colours.

```c++
#include <mono.h>
#include <ptmono30.h>
using mono::geo::Rect;
using mono::ui::TextLabelView;

class AppController
:
    public mono::IApplication
{
    TextLabelView humidityLabel;
    TextLabelView humidityValueLabel;
    TextLabelView temperatureLabel;
    TextLabelView temperatureValueLabel;
public:
    AppController()
    :
        humidityLabel(Rect(0,10,176,20),"humidity"),
        humidityValueLabel(Rect(0,30,176,42),"--.--"),
        temperatureLabel(Rect(0,80,176,20),"temperature"),
        temperatureValueLabel(Rect(0,100,176,42),"--.--")
    {
    }
    void monoWakeFromReset ()
    {
        humidityLabel.setAlignment(TextLabelView::ALIGN_CENTER);
        humidityLabel.setTextColor(TurquoiseColor);
        humidityValueLabel.setAlignment(TextLabelView::ALIGN_CENTER);
        humidityValueLabel.setFont(PT_Mono_30);
        humidityValueLabel.setTextColor(AlizarinColor);
        temperatureLabel.setAlignment(TextLabelView::ALIGN_CENTER);
        temperatureLabel.setTextColor(TurquoiseColor);
        temperatureLabel.setAlignment(TextLabelView::ALIGN_CENTER);
        temperatureValueLabel.setAlignment(TextLabelView::ALIGN_CENTER);
        temperatureValueLabel.setFont(PT_Mono_30);
        temperatureValueLabel.setTextColor(AlizarinColor);
        humidityLabel.show();
        humidityValueLabel.show();
        temperatureLabel.show();
        temperatureValueLabel.show();
    }
    void monoWillGotoSleep () {}
    void monoWakeFromSleep () {}
};
```

## Getting data from the sensor

From the [first part](humidity-hardware.md) of this tutorial, you know how to start a reading from the sensor, but it gets somewhat more complicated to capture and interpret the data from the sensor.

The data from the sensor is a series of bits, where each bit value is determined by the length of each wave.  So I can make my app to trigger on the start of each new wave and then record the time that has passed since the the last wave started.  The triggering can be done by attaching an interrupt handler to the data wire, which is done by using the `InterruptIn` class from the [mbed library](https://developer.mbed.org/handbook/InterruptIn).

Compared to the [first version](humidity-hardware.md), I now have an array `bits` and an index `bitIndex` into this array so that I can collect the bits I read from the sensor. The `requestSensorReading` function now resets `bitIndex` before requesting a new reading, and `IRQ_letGoOfWireAndListen` sets up the function `IRQ_falling` to get called every time there is a [falling edge](https://en.wikipedia.org/wiki/Signal_edge) on the data line from the sensor:

```c++
#include <mono.h>
#include <mbed.h>
using mono::io::DigitalOut;

#define LEADBITS 3
#define TOTALBITS LEADBITS+5*8

class AppController
:
    public mono::IApplication
{
    mono::Timer measure;
    mbed::Ticker ticker;
    mbed::InterruptIn in;
    DigitalOut out;
    uint8_t bits [TOTALBITS];
    size_t bitIndex;
    uint32_t usLastTimeStamp;
public:
    AppController()
    :
        measure(3*1000),
        /// It is important that InterruptIn in initialised...
        in(J_RING1),
        /// ...before DigitalOut because they use the same pin, and the initialisation
        /// sets the pin mode, which must be pull-up.
        out(J_RING1,1,PullUp)
    {
        measure.setCallback<AppController>(this,&AppController::requestSensorReading);
    }
    void monoWakeFromReset ()
    {
        put3V3onTip();
        measure.Start();
    }
    void monoWillGotoSleep ()
    {
        turnOffTip();
    }
    void monoWakeFromSleep () {}
    void put3V3onTip ()
    {
        DigitalOut(VAUX_EN,1);
        DigitalOut(VAUX_SEL,1);
        DigitalOut(JPO_nEN,0);
    }
    void turnOffTip ()
    {
        DigitalOut(JPO_nEN,1);
    }
    void requestSensorReading ()
    {
        bitIndex = 0;
        out = 0;
        ticker.attach_us(this,&AppController::IRQ_letGoOfWireAndListen,18*1000);
    }
    void IRQ_letGoOfWireAndListen ()
    {
        out = 1;
        usLastTimeStamp = us_ticker_read();
        in.fall(this,&AppController::IRQ_falling);
    }
    void IRQ_falling ()
    {
        uint32_t usNow = us_ticker_read();
        uint32_t usInterval = usNow - usLastTimeStamp;
        usLastTimeStamp = usNow;
        uint8_t bit = (usInterval < 100) ? 0 : 1;
        bits[bitIndex] = bit;
        ++bitIndex;
        if (bitIndex >= TOTALBITS)
        {
            in.disable_irq();
            // TODO:
            //async(this,&AppController::collectReadings);
        }
    }
};
```

The `IRQ_falling` function calculates the time difference between the last falling edge on the data from the sensor, and if that interval is less that 100 µs, then the received bit is a 0; otherwise it is a 1.  When enough bits have been received, the interrupt is turn off so that I will stop receiving calls to `IRQ_falling`.

I use the `IRQ_` prefix on functions that are invoked by interrupts to remind myself that such functions should not do any heavy lifting.  That is also why the (to be done) processing of the received bits is wrapped in an [`async` call](https://community.openmono.com/topic/57/mono-sdk-1-2-released).

## Interpreting the data from the sensor

Up until now, it has made no difference whether I was using a DHT11 or DHT22 sensor.  But now I want to implement the `collectReadings` function to interpret the bits I get back from the sensor, and then the type of sensor matters.

I will start with the DHT11 sensor, [which only gives me the integral part of the humidity and temperature value](http://www.micropik.com/PDF/dht11.pdf).  So I need to go through the array of bits, skip the initial handshakes, dig out the humidity, dig out the temperature, and finally update the display with the new values:

```c++
    // DHT11
    void collectReadings ()
    {
        uint16_t humidity = 0;
        for (size_t i = LEADBITS; i < LEADBITS + 8; ++i)
        {
            size_t index = 7 - (i - LEADBITS);
            if (1 == bits[i])
                humidity |= (1 << index);
        }
        uint16_t temperature = 0;
        for (size_t i = LEADBITS + 16; i < LEADBITS + 24; ++i)
        {
            size_t index = 7 - (i - LEADBITS - 16);
            if (1 == bits[i])
                temperature |= (1 << index);
        }
        humidityValueLabel.setText(String::Format("%d%%",humidity)());
        humidityValueLabel.scheduleRepaint();
        temperatureValueLabel.setText(String::Format("%dC",temperature)());
        temperatureValueLabel.scheduleRepaint();
    }
```

For the DHT22 sensor, the [values have one decimal of resolution](https://www.sparkfun.com/datasheets/Sensors/Temperature/DHT22.pdf).  So I need to do a little bit more manipulation to display the reading, because the Mono framework do not support formatting of floating point:

```c++
    // DHT22
    void collectReadings ()
    {
        uint16_t humidityX10 = 0;
        for (size_t i = LEAD; i < LEAD + 16; ++i)
        {
            size_t index = 15 - (i - LEAD);
            if (1 == bits[i])
                humidityX10 |= (1 << index);
        }
        int humiWhole = humidityX10 / 10;
        int humiDecimals = humidityX10 - humiWhole*10;
        uint16_t temperatureX10 = 0;
        for (size_t i = LEAD + 16; i < LEAD + 32; ++i)
        {
            size_t index = 15 - (i - LEAD - 16);
            if (1 == bits[i])
                temperatureX10 |= (1 << index);
        }
        int tempWhole = temperatureX10 / 10;
        int tempDecimals = temperatureX10 - tempWhole*10;
        humidityValueLabel.setText(String::Format("%d.%0d%%",humiWhole,humiDecimals)());
        humidityValueLabel.scheduleRepaint();
        temperatureValueLabel.setText(String::Format("%d.%0dC",tempWhole,tempDecimals)());
        temperatureValueLabel.scheduleRepaint();
    }
```

What is still missing is detecting negative temperatures, unit conversion and [auto sleep](http://developer.openmono.com/en/latest/tutorials/sleep-mode.html), but I will leave that as an excercise.  Of course, you *could* cheat and look at the full app [in MonoKiosk](http://monokiosk.com/app/com-openmono-humidity).


