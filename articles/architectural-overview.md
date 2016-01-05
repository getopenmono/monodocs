# Architectural Overview

what you will read about here...

### Who should read this?

All who wants to understand the concept and thoughts behind the framework

## The 3 abstractions layers

1. mono layer
2. mbed layer
3. cypress layer

In this article we focus mainly on the *mono layer*

## API Overview

diagram of classes by category

## Core Concepts

### Application lifecycle

#### Power On Reset

#### Sleep and Wake-up

### The run loop

#### Callback functions

##### Events

##### Timers

##### Queued interrupts

### The Application Controller

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
* Display System Architecture
* Touch System Architecture
* Wifi & networking
* Power Management Overview
* Memory Management: Stack vs heap objects?
* Coding C++ for bare metal
* The Build System

