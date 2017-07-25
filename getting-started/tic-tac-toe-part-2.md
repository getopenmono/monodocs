# Tic-tac-toe for Mono, part II

In the [first part](tic-tac-toe-part-1.md), you saw how to get Mono to draw on the
screen and how to react to touch input.

In this second part, I will show you how to use timers to turn Mono into an intelligent opponent!

## Growing smart

To get Mono to play Tic Tac Toe, I will need to give it a strategy.  A
very simple strategy could be the following:

1. Place a token on an empty field if it makes Mono win.
1. Place a token on an empty field if it blocks the human opponent from winning.
1. Place a token arbitrarily on an empty field.

Well, it is not exactly Skynet, but it will at least make Mono appear to
have some brains.  In code it translates to the following.

```cpp
void AppController::autoMove ()
{
    timer.Stop();
    // Play to win, if possible.
    for (uint8_t x = 0; x < 3; ++x)
        for (uint8_t y = 0; y < 3; ++y)
            if (board[y][x] == _)
            {
                board[y][x] = O;
                if (hasWinner()) return continueGame();
                else board[y][x] = _;
            }
    // Play to not loose.
    for (uint8_t x = 0; x < 3; ++x)
        for (uint8_t y = 0; y < 3; ++y)
            if (board[y][x] == _)
            {
                board[y][x] = X;
                if (hasWinner())
                {
                    board[y][x] = O;
                    return continueGame();
                }
                else board[y][x] = _;
            }
    // Play where free.
    for (uint8_t x = 0; x < 3; ++x)
        for (uint8_t y = 0; y < 3; ++y)
            if (board[y][x] == _)
            {
                board[y][x] = O;
                return continueGame();
            }
    }
}
```

The `timer` is what controls when Mono should make its move; it is
a Mono framework [Timer](http://developer.openmono.com/en/latest/reference/mono_Timer.html)
that can be told to trigger repeatedly at given number of milliseconds.
I will make the application fire the timer with 1.5 second intervals:

```cpp
class AppController
    ...
{
    ...
private:
    mono::Timer timer;
    void autoMove ();
    void prepareNewGame ();
};

AppController::AppController ()
:
    timer(1500)
{
    ...
}
```

I will control the application by telling `timer` to call
various functions
when it triggers, and then stop and start the `timer` where appropriate.
Conceptually, I can simply tell `timer` to call a function `autoMove` by
```cpp
timer.setCallback(autoMove);
```
but because `autoMove` is a C++ class member-function, I need to help out the poor old C++ compiler by giving it information about which object has the
`autoMove` function, so the incantation will actually be
```cpp
timer.setCallback<AppController>(this,&AppController::autoMove);
```

With that cleared up, I can place the bulk of the control in the
`continueGame` function:

```cpp
void AppController::continueGame ()
{
    updateView();
    whosMove();
    if (hasWinner())
    {
        if (winner() == X) topLabel.setText("You win!");
        else topLabel.setText("Mono wins!");
        timer.setCallback<AppController>(this,&AppController::prepareNewGame);
        timer.start();
    }
    else if (nextToMove == _)
    {
        topLabel.setText("Tie!");
        timer.setCallback<AppController>(this,&AppController::prepareNewGame);
        timer.start();
    }
    else if (nextToMove == X)
    {
        topLabel.setText("Your move");
        topLabel.show();
    }
    else
    {
        topLabel.setText("Thinking...");
        timer.setCallback<AppController>(this,&AppController::autoMove);
        timer.start();
    }
}
```

All that is missing now is a `prepareNewGame` function that prompts for a new game:

```cpp
void AppController::prepareNewGame ()
{
    timer.stop();
    topLabel.setText("Play again?");
}
```

And that is it!  Now you can let your friends try to beat Mono, and when
they fail, you can tell them that *you* created this master mind.
