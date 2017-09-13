# Incrementing a variable on Mono

**This is a brief example of how to show a incrementing number on Mono's display, using the Arduino IDE.**

When Mono (and some Arduino models) runs a program there is more going on than what you can see in the `setup()` and `loop()`. Every time the *loop* is starting over, Mono will do some housekeeping in between. This include such tasks as updating the screen and servicing the serial port.

This means if you use `wait` / `sleep` functions or do long running ntensive tasks, Mono will not have time to update the screen or listening on the serial port. This will also affect Monos ability to receive a reset request, which is important every time you are uploading a new sketch or app.

```eval_rst
.. hint:: If you find your Mono ended up in a ``while(1)`` loop or something similar, see our brief tutorial on [Resetting Mono](resetting_mono.md).
```

To periodically increment a variable, and avoid doing *wait* or *sleep* calls, the following example uses an alternative approach to the *wait* function. To slow down the counting, we use a variable to count loop iterations and an `if` statement to detect when it reaches 1000 and then increment the counter and update the label on the screen.

```eval_rst
.. caution:: When using this method the timing will be highly dependent on what mono is doing for housekeeping.
```


```cpp    
    /***
     * 
     * This is a small example of how to show a counting variable on mono's screen.
     *
     * Instead of using a delay function to slow down the counting, I here use a variable to count loop iterations
     * and an if() to detect when it reaches 1000 and then increment the counter and update the label on the screen.
     * 
     ***/
    #include <mono.h>
    
    mono::ui::TextLabelView textLbl;
    
    int loopItererations;
    int counter;
    
    void setup()
    {
      textLbl = mono::ui::TextLabelView(mono::geo::Rect(0,20,176,20),"Hi, I'm Mono");
      textLbl.setTextColor(mono::display::WhiteColor); 
      textLbl.show();
    }
        
    void loop()
    {
      loopItererations++;
    
      if( loopItererations >= 1000 )
      {
        loopItererations = 0;
        counter++;
        textLbl.setText(mono::String::Format("count: %i", counter));
      }
    }
```