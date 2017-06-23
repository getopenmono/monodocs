# Release 1.4

*November 21th, 2016*

**We corrected some critical power issues in this release and bugs in the _TextLabel_ object.**

### Additions
- We added a HTTP OST class called: _HttpPostClient_, that work like the existing _HttpClient_. The _PostClient_ uses 2 callbacks where you must provide POST body length and data.
- (1.4.2 only) Real Time Clock enabled. Mono now has a running system clock, that can be accessed through the [`DateTime`](http://developer.openmono.com/en/latest/reference/mono_DateTime.html#_CPPv2N8DateTime3nowEv) class.
- (1.4.3 only) Build system always `clean` before building - since we have experienced errors in the dependency system

### Bug Fixes
- Fixed issue that caused the voltage on `VAUX` to changed when Mono went to sleep mode. Now (by default) `VAUX` is 3.3V and 0V in sleep.
- Fixed issue that caused `J_TIP` to change voltage levels in wake and sleep modes. We controlled this issue by limiting the voltage changes. `J_TIP` is 0V by default when Mono is running and in sleep. But when the USB is connected leakage currents will raise the voltage on `J_TIP` to 1.7V.
- Fixed repaint error in _TextLabelView_, caused `setText` to fail.
- Fixed issue in TextRender, that might cause the render to skip glyphs