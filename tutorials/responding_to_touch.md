# Responding to Touch

**In this tutorial we shall see how you can easily respond to touch input. First we just accept any touch input, and later we see how you combine touch and display drawing.**

Mono's touch system is implemented as a responder chain. That means touch input are events traveling down a chain of *responders*, until one decides to act on the event. A *responder* is simply an object that can handle touch events. Responders are not required to act upon a touch event, they can ignore them if they wish. All responsers must subclass from the [`TouchResponder`](../reference/mono_TouchResponder.html) class.

```eval_rst
.. note:: In this tutorial I assume you are somewhat familiar with C++. If you are not, you might wonder more about syntax than about what is really happening. I would suggest you read our article `The C programmers guide to C++ <../articles/c-program-guide-cpp.html>`_ first.
```

## A simple Touch Response

A simple touch responder could be an object handling display dimming. To save battery you might want the screen to dim, after some time of inactivity. Then, if you touch the display the screen should light up again. In this case the touch position is irrelevant.

Let us create a class we call `AutoDimmer` in a file called *auto_dimmer.h*:

```cpp
class AutoDimmer : public mono::TouchResponder {
public:

    mono::Timer dimTimer;

    AutoDimmer();

    void respondTouchBegin(mono::TouchEvent &event);

    void dim();
};
```

Our class inherits from `TouchResponder` and it overwrites the method `respondTouchBegin`. This method gets called on every touch event, regardless on the touch inputs position. To dim the screen after some time, we use a `Timer` object, that calls the `dim()` method when it times out. Lastly, we create a constructor to setup the timer and insert our class into the touch responder chain.

Create an implementation file for our class, called *auto_dimmer.cpp*:

```cpp
AutoDimmer::AutoDimmer() : mono::TouchResponder()
{
    //dim after 3 secs
    dimTimer.setInterval(3000);

    // setup timer callback
    dimTimer.setCallback<AutoDimmer>(this, &AutoDimmer::dim);

    //start dim timer
    dimTimer.start();
}

void AutoDimmer::respondTouchBegin(mono::TouchEvent &event)
{
    //stop timer
    dimTimer.stop();

    //undim screen
    mono::display::IDisplayController *ctrl = mono::IApplicationContext::Instance->DisplayController;
    ctrl->setBrightness(255);

    //restart dim timer
    dimTimer.start();

    //make sure event handling continues
    event.handled = false;
}

void AutoDimmer::dim()
{
    dimTimer.stop();

    //dim screen
    mono::display::IDisplayController *ctrl = mono::IApplicationContext::Instance->DisplayController;
    ctrl->setBrightness(50);
}
```

The implementation file has 3 methods:

### Constructor

We call the parent class' (`TouchResponder`) constructor, that will insert our class' instance into the touch system's responder chain.

In the constructor body we setup the timer that will dim the screen. We give it a timeout interval of 3 seconds and set its callback method to the `dim()` method. Last, we start the timer so the display will dim within 3 seconds.

### Respond to Touch begin

The `RespondTouchBegin` method is an overloaded method from the parent class. When touch events arrive in the responder chain, this method will automatically be called. So within this method we know that a touch has occurred, so we undim the screen and restart the timer. To undim the screen we obtain a pointer to the `DisplayController` from the *application context*. The `DisplayController` has methods to change the brightness of the screen.

We restart the timer so it will dim the screen within 3 seconds again, if no other touch events occurs.

### Dim the screen

Our last method simply stops the timer and dims the screen. It also uses the *application context* to obtain a pointer to the `DisplayController`. We set the dimmed display brightness to 50 out of 255.

## Run the example

To use `AutoDimmer` we must add it as a member variable on an *AppController*. Create a mono project and add our *auto_dimmer.\** files to its project directory. Now add `AutoDimmer` as a member variable on `AppController`:

```cpp
#include "auto_dimmer.h"

class AppController : public mono::IApplication {
public:

    AutoDimmer dimmer;

    AppController();
    // ...
```

Thats it. Go ahead and `make install` the project. You should see that the display brightness changes after 3 secs. And if you touch the display, the brightness should change back to the maximum level.

### Caveats

There is a small caveat in our implementation. Our `AutoDimmer` object might not be the first responder in the chain. Touch events might get handled by an earlier responder in the chain. This can mean we might miss touch events.

To fix this we need to make sure our `AutoDimmer` is the *first responder*, meaning it sits first in the responder chain. Responders are added to the chain as first come, first serve. The simplest approach is to make sure `AutoDimmer` is the first responder to have its constructor called.

## Views that respond to touch

Now that we know how to handle touch input, let us next up the game a bit. Let us take an existing *View* class, that does not respond to touch, and make it respond to touches.

Let us take the [`ProgressBarView`](../reference/mono_ui_ProgressBarView.html) and make it respond to touch input. We want to set its progress position to the *x* coordinate of the touch input. This effective creates a crude *slider*.

### The *ResponderView*

We are going to use the class [`ResponderView`](../reference/mono_ui_ResponderView.html). This is a subclass of the class [`TouchResponder`](../reference/mono_TouchResponder.html), that we used previously. *ResponderView* is a *View* that can handle touch. Unlike *TouchResponder* the *ResponderView* only responds to touches that occur inside its rectangular boundary.

```eval_rst
.. hint:: All *Views* have a *view rect*, the rectangular area they occupy on the screen. This is the active touch area for *ResponderViews*, all touches outside the *view rect* are ignored, and passed on in the responder chain.
```

The *ResponderView* requires you to overload 3 methods, that differ from the ones from *TouchResponder*. These are:

* `void touchBegin(TouchEvent &)`
* `void touchMove(TouchEvent &)`
* `void touchEnd(TouchEvent &)`

These methods are triggered only if the touch are inside the *view rect*. Further, the [`TouchEvent`](../reference/mono_TouchEvent.html) reference they provide are converted to display coordinates for you. This means these are in pixels, and not raw touch values.

If you wish or need to, you can overload the original responder methods from *TouchResponder*. These will be triggered on all touches.

### The simple slider

To realize our simple slider UI component, we create our own class: `Slider`, that will inherit from both *ProgressBarView* and *ResponderView*.

```eval_rst
.. caution:: In C++ a class can inherit from multiple parent classes. In this case we inherit from two classes that themselves inherit from the same parent. This causes ambiguity cases, known as *the diamond problem*. However, for the sake of this tutorial we use this multi-inheritance approach anyway.
```

Create a set of new files called: *slider.h* and *slider.cpp* and add them to a new application project.

Open the *slider.h* file at paste this:

```cpp
#include <mono.h>

class Slider :  // inheritance
	public mono::ui::ProgressBarView, 
	public mono::ui::ResponderView
{
public:

    Slider(const mono::geo::Rect &rct);

	// ResponderView overloads
    void touchBegin(mono::TouchEvent &event);
    void touchEnd(mono::TouchEvent &event);
    void touchMove(mono::TouchEvent &event);

	// Ambiguous View overloads
    void show();
    void hide();
    void repaint();
};
```

Our Slider class inherits the drawing from *ProgressBarView* and the touch listening from *ResponderView*. Both parents define the common View methods: `repaint()`, `show()` and `hide()`. Therefore, to avoid any ambiguity we overload these explicitly.

Next, insert this into the *slider.cpp* implementation file:

```cpp
#include "Slider.h"

Slider::Slider(const Rect &rct) :
    mono::ui::ProgressBarView(rct),
    mono::ui::ResponderView(rct)
{
    this->setMaximum(this->ProgressBarView::viewRect.Width());
    this->setMinimum(0);
}

void Slider::touchBegin(TouchEvent &event)
{
    int relative = event.Position.X() - this->ProgressBarView::viewRect.X();
    
    this->setValue(relative);
    this->ProgressBarView::scheduleRepaint();
}

void Slider::touchEnd(TouchEvent &) { }

void Slider::touchMove(TouchEvent &event)
{
    int relative = event.Position.X() - this->ProgressBarView::viewRect.X();

    this->setValue(relative);
    this->ProgressBarView::scheduleRepaint();
}

void Slider::show()
{
    this->ProgressBarView::show();
    this->ResponderView::show();
}
void Slider::hide()
{
    this->ProgressBarView::hide();
    this->ResponderView::hide();
}

void Slider::repaint()
{
    this->mono::ui::ProgressBarView::repaint();
}
```

For clarity I will go through the code in sections.

##### Constructor

```cpp
Slider::Slider(const Rect &rct) :
    mono::ui::ProgressBarView(rct),
    mono::ui::ResponderView(rct)
{
    this->setMaximum(this->ProgressBarView::viewRect.Width());
    this->setMinimum(0);
}
```

First the constructor, where we call both parent contructors with the *view rectangle* provided. In the body we set the maximum and minimum values for the progress bar. 

We set the maximum value to equal the width of the view. Thereby we avoid any need for a convertion from touch position into a progress percentage.

##### Touch begin & touch move

```cpp
int relative = event.Position.X() - this->ProgressBarView::viewRect.X();
    
this->setValue(relative);
this->ProgressBarView::scheduleRepaint();
```

Here we calculate the *X* position of the touch, with repect to the upper left corner of the *view rect*. This is done by subtracting the *X* offset of the *view rect*. Then we simply set the progressbar value to the relative position.

Finally we explicitly call `scheduleRepaint()` on the *ProgressBarView* parent class.

The content of the `TouchMove` method is identical.

##### Show, hide & repaint

These 3 methods are overloaded to explicitly call the matching method on both parent classes. In both `show` and `hide` we call both parents, to ensure we are listening for touch and will be painted on the screen.

The `repaint` method is an exception. Here we need only to call the  ProgressBar's repaint method, because the other parent does not do any painting.

###  Result

To connect the pieces we need to add our new slider to the *app_controller.h*:

```cpp
#include "slider.h"

class AppController : public mono::IApplication {
public:

    Slider slider;
    	
	...
```

Also, we need to call `show()` on our slider object. In *app_controller.cpp* insert this:

```cpp
AppController::AppController() :
    slider(mono::geo::Rect(10,100,156,35))
{
    slider.show();
}
```

Now go ahead and `make install`, and you should be able to change the progress bars postion by touch input.