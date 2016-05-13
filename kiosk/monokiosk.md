# MonoKiosk

Mono apps are distributed through the [Kiosk](http://monokiosk.com), and you
can get your app into the Kiosk by following the recipe below.

## GitHub

If your source code is hosted on [GitHub](https://github.com), you will need to
make a [GitHub release](https://help.github.com/articles/creating-releases/)
and attach three types of files to the release, namely

- The app description.
- A set of screenshots.
- The binary app itself.

### App description

The release must contain a file named `app.json` that contains the metadata
about your app, for example

```json
{ "id":"com.openmono.tictactoe"
, "name":"Tic Tac Toe"
, "author":"Jens Peter Secher"
, "authorwebsite":"http://developer.openmono.com"
, "license":"MIT"
, "headline":"The classic 3x3 board game."
, "description":
  [ "Play with a fun and exciting game with against another player."
  , "Can you beat your best friend in the most classic of board games?"
  ]
, "binary":"ttt.elf"
, "sourceurl":"https://github.com/getopenmono/ttt"
, "required":["display","touch"]
, "optional":[]
, "screenshots":
  [ "tic-tac-toe-part1.png"
  , "tic-tac-toe-part2.png"
  , "tic-tac-toe-part3.png"
  ]
, "cover": "tic-tac-toe-part2.png"
, "kioskapi": 1
}
```
As you can see, `app.json` refers to three distinct images (`tic-tac-toe-part1.png`,
`tic-tac-toe-part2.png`,`tic-tac-toe-part3.png`) to be used on the app's page
in MonoKiosk, so these three files must also be attached to the GitHub release.
The metadata also refers to the app itself (`ttt.elf`), the result of you building
the application, so that file must also be attached to the release.

The format of the  metadata needs to be very strict, because it is used to
automatically create an entry for your app in MonoKiosk.  The metadata must
be in [JSON](http://json.org) format, and the file must be named `app.json`.
In the following, we will describe the format in detail.

#### id

The `id` must be unique within the Kiosk, so you should use [reverse domain name notation](https://en.wikipedia.org/wiki/Reverse_domain_name_notation) like `uk.homebrewers.brewcenter`.

#### name

The name of the app as it should appear to people browsing the Kiosk.

#### author

Your name or Organisation, as it should appear to people browsing the Kiosk.

#### authorwebsite

An *optional* URL to your (organisation's) website.

#### license

How other people can use your app and the source code.  We acknowledges the
following licenses:

- [MIT](https://opensource.org/licenses/MIT)
- [GPL](http://www.gnu.org/licenses/gpl-3.0.html)
- [LGPL](http://www.gnu.org/licenses/lgpl-3.0.html)

If you feel that you need another license supported, take it up in the
[forum](http://forum.openmono.com).

#### headline

Your headline that accompanies the app on the Kiosk.

#### description

A list of paragraphs that give other people a detailed desription of
the app, such as why they would need it and what it does.

#### binary

The name of the [ELF](https://en.wikipedia.org/wiki/Executable_and_Linkable_Format)
file which has been produced by your compiler, and which you have attached to
the release.

#### sourceurl

An URL to the source code of the app.

#### required

A list of hardware that must be present in a particular Mono to run the app.
The acknowledged hardware is as follows.

- accelerometer
- buzzer
- clock
- display
- jack
- temperature
- touch
- wifi
- bluetooth

#### optional

A list of Mono hardware that the app will make use of if present.
The acknowledged hardware is the same as for the `required` list.

#### screenshots

A list of images that will be presented in the Kiosk alongside the app
description.

All images must be either 176x220 or 220x176 pixes, and they must be attached
to the release.

#### cover

One of the screenshots that you want as cover for app in the Kiosk.

#### kioskapi

The format of the metadata.  The format described here is version 1.

## How to get your app included

When you have created a new (version) of your app, you can contact us
at `kiosk@openmono.com` with the URL of your release (eg.
`https://api.github.com/repos/getopenmono/ttt/releases/tags/v0.1.0`),
and we will do a sanity check of the app and add to the official list
used by the Kiosk.

For GitHub, the url for a release is `https://api.github.com/repos/`:owner`/`:repo`/releases/tags/`:tag
