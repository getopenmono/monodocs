# Common Misconceptions & Worst Practice

***To clear out, what we imagine will be common mistakes, let's go through some senarios that you should avoid - at least!***

### Who should read this?

Mono API and application structure might be new to you, if you previously programmed only for Arduino or similar embedded devices. We are aware of our framework might be quite unfamiliar to bare metal developers, who expect to have full access and control, from `main()` to `return 0`.

Mono Framework is advanced and its good performance depends on you, following the best practice guide lines. Read this, and you can avoid the most basic mistakes that degrade Mono's functionality.

## No `while(1)`'s

First, never ever create your own run loop! Never do this:

```cpp

	void AppController::monoWakeFromReset()
	{
		// do one time setups ...
		
		// now lets do repetitive tasks, that I want to control myself
		while(1)
		{
			//check status of button
			
			// check something else
			
			// maybe update the screen
			
			// increment some counter
		}
		// we will never return here
	}

```

Try to do this, and you will find Mono completely unresponsive. The USB port will not work, the programmer (monoprog) will not work, along with a whole bunch of other stuff.

Like other applications in modern platforms, Mono applications uses an internal run loop. If you create your own, the internal run loop will not progress. All features that depend on the run loop will not work. Timers will not run, display system will not work, and worst `monoprog` cannot reset mono, to upload a new app.

If you want to do repetitive tasks, that should run always (like `while(1)`), you should instead utilize the run loop. You can inject jobs into the run loop by implementing an interface called [IRunLoopTask](../reference/mono_IRunLoopTask.md). This will allow you to define a method that gets called on each run loop iteration. That's how you do it. We shall not go into more details here, but just refer to the tutorial [Using the Run Loop](../tutorials/using-the-run-loop.md)

### No busy waits

Many API's (including Mono's), allows you to do busy waits like this:

```cpp

	// do something
	wait_ms(500); // wait here for 0.5 secs
	
	// do something else
```

It is really covenient to make code like this, but it is bad for performance! For half a second you just halt the CPU - it does nothing. The application run loop is halted, so all background tasks must wait as well. The CPU runs at 66 Mhz, imagine all code it could have executed in that half second!

Instead of halting the CPU like this, you should use callbacks to allow the CPU to do other stuff, while you wait:

```cpp

	// do someting
	mono::Timer::callOnce<MyClass>(500, this, &MyClass::doSomethingElse); // do something else in 0.5 secs
```

By using the [Timer](../reference/mono_Timer.md) class, and encapsulating the "do something else" functionality in a method - you free the CPU to do useful stuff while you wait. To learn more about callbacks see the tutorial: [Callbacks in C++](tutorials/callbacks.md).

## Extensive use of `new` or `malloc`

The C++ `new` operator uses the *stdlib* function `malloc` to allocate memory on the heap. And it is very easy and convenient to use the heap:

```cpp

	// object allocation on the heap - because Qt and Obj-C Cocoa uses this scheme!
	mono::geo::Rect *bounds = new mono::geo::Rect(0,0,100,20);
	mono::ui::TextLabelView *txtLbl = new mono::ui:TextLabelview(*bounds, "I'm on the heap!");
	
	//pass the pointer around
	return txtLbl;

```

What happened to the `bounds` pointer, that had a reference to a [Rect](../reference/mono_geo_Rect.md) object? Nothing happened, the object is still on the heap and we just lost the reference to it. Our application is leaking memory. And that is one issue with using the heap. We do not have a *Garbage Collector* , so you must be careful to always free your objects on the heap.

And it gets worse, the heap on Mono PSoC5 MCU is not big - it is just 16 Kb. You might run out of heap quicker than you expect. At that point `malloc` will start providing you with `NULL` pointers.

### Use heap for Asynchronous tasks

There are some cases where you must use the heap, for example this will not work:

```cpp

	void getTemp()
	{
		// say we got this variable from the temperature sensor
		int celcius = 22;
	
		char tempStr[100]; // make a local buffer variable to hold our text
	
		// format a string of max 100 chars, that shows the temperature
		snprintf(tempStr, 100, "the temperature is: %i C",celcius);
	
		renderOnDisplayAsync(tempStr);
	}

```

Here we have an integer and want to present its value nicely wrapped in a string. It is a pretty common thing to do in applications. The issue here is that display rendering is asynchronous. The call to `renderOnDisplayAsync` will just put our request in a queue, and then return. This means our buffer is removed (deallocated) as soon as the `getTemp()` returns, because it is on the stack.

Then, when its time to render the display there is no longer a `tempStr` around. We could make the string buffer object global, but that will take up memory - especially when we do not need the string.

In this case you should the heap! And luckily we made a [String](../reference/mono_String.md) class that does this for you. It store its content on the heap, and keeps track of references to the content. As soon as you discard the last reference to the content, it is automatically freed - no leaks!

The code from above becomes:

```cpp
	
	int celcius = 22; // from the temp. sensor
	
	// lets use mono's string class to keep track of our text
	mono:String tempStr = mono::String::Format("the temperature is: %i C",celcius);
	
	renderOnDisplayAsync(tempStr);

```

That's it. Always use Mono's [String](../reference/mono_String.md) class when handling text strings. It is lightweight, uses data de-duplication and do not leak.

*(The method `renderOnDisplayAsync` is not a Mono Framework method, it is just for demonstration.)*

## Avoid using the Global Context

If you write code that defines variables in the global context, you might encounter strange behaviours. Avoid code like this:

```cpp

	// I really need this timer in reach of all my code
	mono::Timer importantTimer;
	
	// some object I need available from everywhere
	SomeClass myGlobalObject;
	
	class AppController : public mono::IApplication
	{
		// ...
	};
```

If you use Mono classes inside `SomeClass` or reference `myGlobalTimer` from it, when you will likely run into problems! The reason is Mono's initialization scheme. A Mono application's start procedure is quite advanced, because many things must be setup and ready. Some hardware components depend on other components, and so on.

When you define global variables (that are classes) they are put into C++'s *global initializer lists*. This means they are defined *before* `monoWakeFromReset()` is executed. You can not expect periphrals to work before `monoWakeFromReset` has been called. When it is called, the system and all its features is ready. If you interact with Mono classes in code you execute before, it is not guaranteed to work properly.

If you would like to know more about the startup procedures of mono applications and how application code actually loads on the CPU, see the [Boot and Startup procedures](../articles/boot-and-startup.md) in-depth article.

## Direct H/W Interrupts

If you are an exerienced embedded developer, you know interrupts and what the requirements to their ISR's are. If you are thinking more like: "What is ISR's?" Or, "ISR's they relate to IRQ's right?" - then read on because you might make mistakes when using interrupts.

First, let's see some code that only noobs would write:

```cpp

	// H/W calls this function on pin state change, for example
	void interruptServiceRoutine()
	{
		flag = true;
		counter += 1;
		
		//debounce?
		wait_ms(200);
	}
```

With the `wait_ms()` call, this interrupt handler (or ISR) will always take 200 ms to complete. Which is bad. A rule of thumb is that ISR's should be fast. You should avoid doing any real work inside them, least of all do busy waits.

Mono Framework is build on top of mbed, that provides classes for H/W Timer interrupts and input triggered interrupts. But because you should never do real work inside interrupt handlers, you normally just set a flag and then check that flag every run loop iteration.

We have includes classes that does all this for you. We call them *Queued Interrupts*, and we have an in-depth article about the topic: [Queued callbacks and interrupts](../articles/queued-callbacks.md). There are the [QueuedInterrupt](../reference/mono_QueueInterrupt.md) class, that trigger a queued (run loop based) interrupt handler when an input pin changes state. And the [Timer](../reference/mono_Timer.md) class, that provides a queued version of hardware timer interrupts.

We strongly encourage you to use the queued versions of timers and interrupts, since you avoid all the issues related to real H/W interrupts like: reentrancy, race-conditions, volatile variable, dead-locks and more.