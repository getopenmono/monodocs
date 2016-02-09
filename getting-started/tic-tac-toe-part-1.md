# Tic-tac-toe for Mono

In this tutorial I will teach you how to program Mono's display and touch device by creating a tiny
game.

## Anatomy of a Mono application

Mono apps can be written inside the Arduino IDE, but if you really want be a pro, you can write
Mono apps directly in C++.  For that you will need to implement an `AppController` with at least three functions.  So I will start there, with my `app_controller.h` header file:

```cpp
#include <mono.h>

class AppController
:
    public mono::IApplication
{
public:
    AppController ();
    void monoWakeFromReset ();
    void monoWillGotoSleep ();
    void monoWakeFromSleep ();
};
```

My matching `app_controller.cpp` implementation file will start out as this:

```cpp
#include "app_controller.h"

AppController::AppController ()
{
}

void AppController::monoWakeFromReset ()
{
}

void AppController::monoWakeFromSleep ()
{
}

void AppController::monoWillGotoSleep ()
{
}
```

Now I have a fully functional Mono application!  It does not do much, but hey, there it is.

## Screen and Touch

[Tic Tac Toe](https://en.wikipedia.org/wiki/Tic-tac-toe) is played on a 3-by-3 board, so let me
sketch out the layout something like this:

```
   Tic Tac Toe
+---+ +---+ +---+
|   | |   | |   |
+---+ +---+ +---+
+---+ +---+ +---+
|   | |   | |   |
+---+ +---+ +---+
+---+ +---+ +---+
|   | |   | |   |
+---+ +---+ +---+
```

I will make the `AppController` hold the board as an array of arrays holding the tokens `X` and `O`, and also a token `_` for an empty field:

```cpp
class AppController
    ...
{
    ...
    enum Token { _, X, O };
    Token board[3][3];
};
```

For simplicity, I do not want Mono to make any moves by itself (yet); I just want two players to
take turns by touching the board.  So I need to show the board on the screen, and I want each
field of the board to respond to touch.

This kind of input and output can in Mono be controlled by the
[`ResponderView`](http://developer.openmono.com/en/latest/reference/mono_ui_ResponderView.html).
It is a class that offers a lot of functionality out of the box, and in my case I only need to override two methods, `repaint` for generating the output and `TouchBegin` for receiving input:

```cpp
class TouchField
:
    public mono::ui::ResponderView
{
    void TouchBegin (mono::TouchEvent &);
    void repaint ();
};

class AppController
    ...
{
    ...
    TouchField fields[3][3];
};
```

Above I have given `AppController` nine touch fields, one for each coordinate on the board.  To make a `TouchField` able to paint itself, it needs to know how to get hold of the token it has
to draw:

```cpp
class TouchField
    ...
{
    ...
public:
    AppController * app;
    uint8_t boardX, boardY;
};
```

With the above information, I can make a `TouchField` draw a circle or a cross on the screen using
the geometric classes [`Point`](http://developer.openmono.com/en/latest/reference/mono_geo_Point.html),
[`Rect`](http://developer.openmono.com/en/latest/reference/mono_geo_Rect.html), and the
underlying functionality it inherits from `ResponderView`.  The `ResponderView` is a subclass of
[`View`](http://developer.openmono.com/en/latest/reference/mono_ui_View.html), and all Views have a
[DisplayPainter](http://developer.openmono.com/en/latest/reference/mono_display_DisplayPainter.html)
named `painter` that takes care of actually putting pixel on the screen:


```cpp
using mono::geo::Point;
using mono::geo::Rect;

void TouchField::repaint ()
{
    // Clear background.
    painter.drawFillRect(viewRect,true);
    // Show box around touch area.
    painter.drawRect(viewRect);
    // Draw the game piece.
    switch (app->board[boardY][boardX])
    {
        case AppController::X:
        {
            painter.drawLine(Position(),Point(viewRect.X2(),viewRect.Y2()));
            painter.drawLine(Point(viewRect.X2(),viewRect.Y()),Point(viewRect.X(),viewRect.Y2()));
            break;
        }
        case AppController::O:
        {
            uint16_t radius = viewRect.Size().Width() / 2;
            painter.drawCircle(viewRect.X()+radius,viewRect.Y()+radius,radius);
            break;
        }
        default:
            // Draw nothing.
            break;
    }
}
```

Above, I use the View's `viewRect` to figure out where to draw.  The `viewRect` defines the View's
position and size on the screen, and its methods `X()`, `Y()`, `X2()`, and `Y2()` give me the screen coordinates of the View.  The method `Position()` is just a shortcut to get X() and Y() as
a Point.

With respect to the board, I index multidimensional arrays by [row-major
order](https://en.wikipedia.org/wiki/Row-major_order) to please you old-school C coders out there.
So it is `board[y][x]`, thank you very much.

Well, now that each field can draw itself, we need the `AppController` to setup the board and
actually initialise each field when a game is started:

```cpp
using mono::ui::View;

void AppController::startNewGame ()
{
    // Clear the board.
    for (uint8_t x = 0; x < 3; ++x)
        for (uint8_t y = 0; y < 3; ++y)
            board[y][x] = _;
    // Setup touch fields.
    const uint8_t width = View::DisplayWidth();
    const uint8_t height = View::DisplayHeight();
    const uint8_t fieldSize = 50;
    const uint8_t fieldSeparation = 8;
    const uint8_t screenMargin = (width-(3*fieldSize+2*fieldSeparation))/2;
    uint8_t yOffset = height-width-(fieldSeparation-screenMargin);
    for (uint8_t y = 0; y < 3; ++y)
    {
        yOffset += fieldSeparation;
        uint8_t xOffset = screenMargin;
        for (uint8_t x = 0; x < 3; ++x)
        {
            // Give each touch field enough info to paint itself.
            TouchField & field = fields[y][x];
            field.app = this;
            field.boardX = x;
            field.boardY = y;
            // Tell the view & touch system where the field is on the screen.
            field.setRect(Rect(xOffset,yOffset,fieldSize,fieldSize));
            // Next x position.
            xOffset += fieldSize + fieldSeparation;
        }
        // Next y position.
        yOffset += fieldSize;
    }
    continueGame();
}
```

Above I space out the fields evenly on the bottom part of the screen, using the `DisplayWidth()` and `DisplayHeight()` to get the full size of the screen, and while telling each field where
it should draw itself, I also tell the field which board coordinate it represents.

Before we talk about the game control and implement the function `continueGame`,
let us hook up each field so that it responds to touch events:

```cpp
using mono::TouchEvent;

void TouchField::TouchBegin (TouchEvent & event)
{
    app->humanMoved(boardX,boardY);
}
```

Above the touch event is implicitly translated to a board coordinate (because each field knows its
own board coordinate) and passed to the `AppController` that holds the board and controls the game
play.

## Game status display

To inform the players what is going on, I want the top of the display to show a status message. And I also want to keep track of which player is next:

```cpp
class AppController
    ...
{
    ...
    mono::ui::TextLabelView topLabel;
    Token nextToMove;
};

using mono::ui::TextLabelView;

AppController::AppController ()
:
    topLabel(Rect(0,10,View::DisplayWidth(),20),"Tic Tac Toe")
{
    topLabel.setAlignment(TextLabelView::ALIGN_CENTER);
}
```

A [`TextLabelView`](http://developer.openmono.com/en/latest/reference/mono_ui_TextLabelView.html)
is a View that holds a piece of text and displays this text in inside its `viewRect`.  I can now
change the label at the top of the screen depending on the state of the game after each move by using `setText()`, followed by a call to `show()` to force the `TextLabelView` to repaint:

```cpp
void AppController::continueGame ()
{
    updateView();
    whosMove();
    if (hasWinner())
    {
        if (winner() == X) topLabel.setText("X wins!");
        else topLabel.setText("O wins!");
    }
    else if (nextToMove == _) topLabel.setText("Tie!");
    else if (nextToMove == X) topLabel.setText("X to move");
    else topLabel.setText("O to move");
    topLabel.show();
}
```

The `updateView()` function simply forces all the fields to repaint:

```cpp
void AppController::updateView ()
{
    for (uint8_t y = 0; y < 3; ++y)
        for (uint8_t x = 0; x < 3; ++x)
            fields[y][x].show();
}
```

## Game control

I now need to implement functionality that decides which player should move next and whether there
is a winner.  First, I can figure out who's turn it is by counting the number of game pieces for both players, and placing the result in `nextToMove`.  If `nextToMove` gets the value `_`, then it means that the board is full:

```cpp
void AppController::whosMove ()
{
    uint8_t xPieces = 0;
    uint8_t oPieces = 0;
    for (uint8_t y = 0; y < 3; ++y)
        for (uint8_t x = 0; x < 3; ++x)
            if (board[y][x] == X) ++xPieces;
            else if (board[y][x] == O) ++oPieces;
    if (xPieces + oPieces >= 9) nextToMove = _;
    else if (xPieces <= oPieces) nextToMove = X;
    else nextToMove = O;
}
```

Finding out whether there is a winner is just plain grunt work, checking the board for
three-in-a-row:

```cpp
bool AppController::hasThreeInRow (Token token)
{
    // Check columns.
    for (uint8_t x = 0; x < 3; ++x)
        if (board[0][x] == token &&
            board[1][x] == token &&
            board[2][x] == token
        ) return true;
    // Check rows.
    for (uint8_t y = 0; y < 3; ++y)
        if (board[y][0] == token &&
            board[y][1] == token &&
            board[y][2] == token
        ) return true;
    // Check diagonal.
    if (board[0][0] == token &&
        board[1][1] == token &&
        board[2][2] == token
    ) return true;
    // Check other diagonal.
    if (board[0][2] == token &&
        board[1][1] == token &&
        board[2][0] == token
    ) return true;
    return false;
}

AppController::Token AppController::winner ()
{
    if (hasThreeInRow(X)) return X;
    if (hasThreeInRow(O)) return O;
    return _;
}

bool AppController::hasWinner ()
{
    return winner() != _;
}
```

Lastly, I need to figure out what to do when a player touches a field.  If the game has ended, one
way or the other, then I want to start a new game, no matter which field is touched;  If the player
touches a field that is already occupied, then I ignore the touch;  Otherwise, I place the proper piece on the board:

```cpp
void AppController::humanMoved (uint8_t x, uint8_t y)
{
    if (nextToMove == _ || hasWinner()) return startNewGame();
    else if (board[y][x] != _) return;
    else board[y][x] = nextToMove;
    continueGame();
}
```

## Fallen asleep?

To wrap thing up, I want Mono to start a new game whenever it comes out of a reset or sleep:

```cpp
void AppController::monoWakeFromReset ()
{
    startNewGame();
}

void AppController::monoWakeFromSleep ()
{
    startNewGame();
}
```

Well there you have it: An astonishing, revolutionary, new game has been born!  Now your job is to type it all in.
