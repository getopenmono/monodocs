#include <mono.h>
#include <mbed.h>

class AppController
:
    public mono::IApplication
{
    mono::Timer measure;
    mbed::Ticker ticker;
    mono::io::DigitalOut out;
    void put3V3onTip ()
    {
        DigitalOut(VAUX_EN,1);
        DigitalOut(VAUX_SEL,1);
        DigitalOut(JPO_nEN,0);
    }
    void requestSensorReading ()
    {
        out = 0;
        ticker.attach_us(this,&AppController::letGoOfWire,18*1000);
    }
    void letGoOfWire ()
    {
        out = 1;
    }
public:
    AppController()
    :
        measure(3*1000),
        out(J_RING1,1,PullUp),
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
        DigitalOut(JPO_nEN,1);
    }
    void monoWakeFromSleep () {}
};
