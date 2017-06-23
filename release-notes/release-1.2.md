# Release 1.2

*September 12th, 2016*

**We have a new version of the framework out, with mostly bug fixes**

#### [`HttpClient`](https://github.com/getopenmono/mono_framework/blob/master/http_client.h) supports customs TCP ports

The interim class for doing HTTP get requests now has the ability to use other ports than 80. You simply insert a custom port in the passed URL - like: `http://192.168.1.5:3000/api/hello`

The request will then be directed to port 3000.

#### New minimal project template

When you create new projects with `monomake project myNewProject`, they are pretty verbose and cluttered with comments. These serve as a help to new developers, but they become irrelevant when you get to know the API.

`monomake` now has a `--bare` switch when creating new projects, that will use a minimalistic template without any comments or example code. You use it like this:

```
$ monomake project --bare my_new_project
```

#### New 30 pt font added

The API now includes a larger font, that you can optionally use in `TextLabelView`'s:

```
#include <ptmono30.h>
mono::ui::TextLabelView lbl(Rect(...), "Hello");
lbl.setFont(PT_Mono_30);
lbl.show();
```

Since the font are bitmaps, they use significant amounts of memory. Therefore the new font is only included in your application if you actually use it. That is, use must define it with the `#include` directive, as shown above.

See the API for changing the font [`TextLabelView.setFont(...)`](http://developer.openmono.com/en/latest/reference/mono_ui_TextLabelView.html#_CPPv2N13TextLabelView7setFontER8MonoFont)

#### Shorthand function for asynchronous function calls

To make dispatching function calls to background handling easier, we added a new global function called: `async` in the `mono` namespace. The function injects your function into the run loop, such that it will be handled at first coming opportunity. The `async` call is really just a shorthand for a [`Timer`]() that has a timeout of `0`.

Example with C++ method:

```
mono::async<MyClass>(this, &MyClass::handleLater);
```

Example with C function:

```
mono::async(&myFunction);
```

### Bug fixes and other improvements

* Optimized text glyph rendering in `TextLabelView`
* SD Card SPI clock speed increased to 8.25 MHz
* Fixed cropping bug in `ImageView`
* Fixed bug in `BMPImage` that caused a crash then invoking *copy constructor*.
* Fixed bug in the Queue class, that could caused Mono to freeze
* Fixed wrong premise on `String`'s memory management.
* Fixed issue that caused `make clean` to not remove all object files
* Fixed `make clean` such that it works on Windows Command Prompt - and only PowerShell.

### Download

Goto our Documentation page to download the new SDK version:

http://developer.openmono.com/en/latest/getting-started/install.html