# Counting variable on mono's screen.

**This is a small example of how to show a counting variable on mono's screen.**

```eval_rst
.. warning:: This is a *draft article*, that is *work in progress*. It still needs some work, therefore you might stumble upon missing words, typos and unclear passages.
```

When mono (and some Arduinos) runs a program there is more going on than what you can see in the setup() and main() loop. Every time the main loop is starting over, mono will do some housekeeping. This includes tasks as updating the screen and servicing the serial port.
This means that if you use wait functions or do long intensive tasks in the main loop, mono will never have time for updating the screen or listening to the serial port. This will also affect monos ability to receive a reset announcment, which is important every time you are uploading a new sketch.

If you are running into this you can always put mono into bootloader manually

1. press and hold down the user button on the side.
2. press and release the reset switch with a clips.
3. release the user button.

To avoid doing this every time the following example uses an alternative to the wait function. To slow down the counting, we here use a variable to count loop iterations and an if() to detect when it reaches 1000 and then increment the counter and update the label on the screen.

```eval_rst
.. warning:: When using this method the timing will be highly dependant on what mono is oing for housekeeping.
```

 For the time being the housekeeping is not optimized, we will work on this in near future. This means that the timing in your program will change when we update the framework. We are working on making a tutorial that shows how to make time-critical applications.
    
    /***
     * 
     * This is a small example of how to show a counting variable on mono's screen.
     *
     * Instead of using a delay function to slow down the counting, I here use a variable to count loop iterations
     * and an if() to detect when it reaches 1000 and then increment the counter and update the label on the screen.
     * 
     ***/
    #include <mono.h>
    
    mono::ui::TextLabelView textLbl(mono::geo::Rect(0,20,176,20),"Hi, I'm Mono");
    
    int loopItererations;
    int counter;
    
    void setup()
    {
      textLbl.setTextColor(mono::display::WhiteColor); 
      textLbl.show();
    }
        
    void loop()
    {
      loopItererations++;
    
      if( loopItererations >= 2000 )
      {
    loopItererations = 0;
    counter++;
    textLbl.setText(mono::String::Format("count: %i", counter));
      }
    }
    