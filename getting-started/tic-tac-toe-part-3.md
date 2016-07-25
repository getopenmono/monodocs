# Tic-tac-toe for Mono, part III

In the [first part](tic-tac-toe-part-1.md), you saw how to get Mono to draw on the screen and how to react to touch input.

In the [second part](tic-tac-toe-part-2.md), you saw how to use timers to turn Mono into an intelligent opponent.

In this third part, I will show you how to extend battery life and how to calibrate the touch system.

## Getting a Good Night's Sleep

It is important to automatically put Mono to sleep if you want to conserve your battery.  The battery lasts less than a day if the screen is permanently turned on.  On the other hand, if Mono only wakes up every second to make a measurement of some sort, then the battery will last a year or thereabouts.
What I will do in this app, is something in between these two extremes.

In it's simplest form, an auto-sleeper looks like this:
```cpp
class AppController
    ...
{
    ...
private:
    mono::Timer sleeper;
    ...
};

AppController::AppController ()
:
    sleeper(30*1000,true),
    ...
{
    sleeper.setCallback(mono::IApplicationContext::EnterSleepMode);
    ...
}

void AppController::continueGame ()
{
    sleeper.Start();
    ...
}
```


The `sleeper` is a single-shot [Timer](http://developer.openmono.com/en/latest/reference/mono_Timer.html), which means that it will only fire once.  And by calling `Start` on `sleeper` every time the game proceeds in `continueGame`, I ensure that timer is restarted whenever something happens in the game, so that `EnterSleepMode` is only called after 30 seconds of inactivity.

## It is Better to Fade Out than to Black Out

Abruptly putting Mono to sleep without warning, as done above, is not very considerate to the indecisive user.  And there is room for everyone here in Mono world.

So how about slowly fading down the screen to warn about an imminent termination of the exiting game?

Here I only start the `sleeper` timer after the display has been dimmed:
```cpp
class AppController
    ...
{
    ...
private:
    mono::Timer dimmer;
    void dim ();
    ...
};

using mono::display::IDisplayController;

AppController::AppController ()
:
    dimmer(30*1000,true),
    ...
{
    dimmer.setCallback<AppController>(this,&AppController::dim);
    ...
}

void AppController::dim ()
{
    dimmer.Stop();
    IDisplayController * display = IApplicationContext::Instance->DisplayController;
    for (int i = display->Brightness(); i >= 50; --i)
    {
        display->setBrightness(i);
        wait_ms(2);
    }
    sleeper.Start();
}
```
The `dimmer` timer is started whenever there is progress in the game, and when `dimmer` times out, the `dim` method turns down the [brightness](http://developer.openmono.com/en/latest/reference/mono_display_IDisplayController.html) from the max value of 255 down to 50, one step at a time.

Oh, I almost forgot, I need to turn up the brightness again when the the dimmer resets:
```cpp
void AppController::continueGame ()
{
    IApplicationContext::Instance->DisplayController->setBrightness(255);
    sleeper.Stop();
    dimmer.Start();
    ...
}

```

So there you have it, saving the environment and your battery at the same time!
