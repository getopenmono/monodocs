<!-- --- title: Architectural Overview : mono -->

what you will read about here...

### Who should read this?

All who wants to understand the concept and thoughts behind the framework

## The 3 abstractions layers

The Mono Framework consists of a set of C++ classes, all build on top of the mbed library created by ARM. The full mono software environment consists of 3 levels of abstractions:

1. mono layer
2. mbed layer (including most of stdlib)
3. cypress layer

In this article we focus mainly on the *mono layer*

## API Overview

Below is a diagram of the features provided by the framework. These are the high-level classes that makes it easy to use mono build-in periperals.

![Mono Framework Feature Overview](mono-overview.svg)



## Core Concepts

### Application lifecycle

* no physical power off switch - power to CPU is always present.
* your application if not likely to reset ofte
* your app lifespan is very long

#### Power On Reset

* when power becomes present after battery outage
* after you just downloaded a new application to mono

#### Sleep and Wake-up

* handle when mono goes to sleep
* handle when mono wakes from sleep
* for the lazy: you may just software reset on "wake from sleep"
* as default the user button will sleep/wake mono

### The run loop

* The frameowek abtracts away a lot of periodic tasks and house-keeping.
* like modern GUI systems application handles events
* two application types: event based and real-time

#### Callback functions

* we have callback functions for C++
* beside C function pointers, you can use C++ member pointers (type info is preserved!)

```c++
someObject.setCallback<MyClass>(this, &MyClass::MyHandler);
```

##### Events

* most apps a events based, they change state on events
* events are touch input, power/sleep triggers or button interrupts
* events are handled in callback functions and member method overrides
* a todo list app changes state on touch events, between events it does nothing

##### Timers

* Timers trigger a periodic event handler callback
* Real-Time apps might update its state/content on a regular interval
* Timers can also be used to call a function at some point in the future (as soon as possible).

##### Queued interrupts

* in embedded environment interrupts are hardware triggers, that call a C function (the ISR)
* the ISR should be fast and return very quickly - a lot of concurrency issues arise when using ISR.
* mono uses Queued interrupt, where the ISR is handled in the run loop.
* no concurrency issues
* you can longer lived ISR's
* they can debounce your hardware input signals, to create more robust handling of button or switches

### The Application Controller

All application must have a app controller - this is there entry point

#### Required virtual methods



#### Application Entry Point & Startup

1. static inits
2. main func
3. app ctrl POR method
4. run loop

#### The Bootloader

## Best Pratice

some do and dont's

## Further reading

in depth articles:

* Boot and Startup procedures
* Queued callbacks and interrupts
* [[Display System Architecture|display_system_architecture]]
* Touch System Architecture
* Wifi & networking
* Power Management Overview
* Memory Management: Stack vs heap objects?
* Coding C++ for bare metal
* The Build System

