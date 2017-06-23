# Release 1.5

*January 23rd, 2017*

**_In this 1.5 release we have focused on tooling, there is no feature additions to the library code. We have added a brand new graphical user interface to manage creation of mono application projects._**

### Introducing Monomake UI application

We have added a UI for our standard console based _monomake_ tool. The UI make the task of creating new projects and installing existing applications on Mono easy and friendly. We did this to help people who are not familiar with the terminal, and just want to install an application on Mono.

However, the best of all is this new Monomake UI enables us to achieve one-click application installs through MonoKiosk. Our new tool registers the URL scheme: `openmono://` and associate with ELF files.

#### Integration with Atom

We know the choice of editor is kind of a religion. Therefore we won't force a specific editor on you. However, should linger undecided for an editor, GitHub have made a fine cross-platform editor called [Atom](https://atom.io). If you have Atom installed on your system, our new Monomake UI takes advantage of it right away. New project can be opened in Atom and you can open recent projects in Atom.

Should you choose to use Atom, we strongly recommend installing the [autocomplete-clang](https://atom.io/packages/autocomplete-clang) package. This package enables as-you-type auto complete suggestions. It also display the inline documentation present in Mono Framework. (Windows users will need to install the [clang compiler](http://releases.llvm.org/download.html).)

### Bridging the gap to our Arduino plugin

We have to admit, have we unintentionally stalled the Arduino compatibility plug-in for the Arduino IDE. In this release we right that by bringing the 1.5 library to Arduino.