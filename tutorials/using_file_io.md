# Using file I/O

***In this tutorial we will see how to read and write files on an SD card.*** 

Mono has a Micro SD Card slot and currently supports communicating with an SD card using an [SPI](http://elm-chan.org/docs/mmc/mmc_e.html) interface. We have included both SD card I/O and FAT32 file system I/O in our framework. As soon as you have setup the SD card I/O you can use the familiar `stdio.h` file I/O.

## Get an SD Card

First order of business is for you to obtain a MicroSD Card and format in good ol' FAT32. Then insert the card into Mono's slot and fire up a new project:

```
$ monomake project fileIO --bare
Creating new bare mono project: fileIO...
 * fileIO/app_controller.h
 * fileIO/app_controller.cpp
Writing Makefile: fileIO/Makefile...
Atom Project Settings: Writing Auto complete includes...
```

```eval_rst
.. note:: Notice that we use the switch ``--bare`` when we created the project. This option strips all comments from the template code. This way you have a less verbose starting point.
```

Now `cd` into the `fileIO` directory and open the code files in your favourite code editor.

## Initalizing the SD Card

At this time we have yet to create a real abstraction layer for the file system initialization. Until we do, you need to initialize the SD card communication yourself. Therefore open *app_controller.h* and add these lines:

```cpp
	#include <mono.h>
	// import the SD and FS definitions
	#include <SDFileSystem.h>
	#include <stdio.h>

	class AppController : public mono::IApplication {
	public:

		SDFileSystem fs; // create an instance of the FS I/O

    	AppController();
```

Here we include the definitions for the both the SD card I/O and the file I/O. Next, we need to contruct the `fs` object in `AppController`'s constructor. Go to *app_controller.cpp*:

```cpp
	AppController::AppController() :
		fs(SD_SPI_MOSI, SD_SPI_MISO, SD_SPI_CLK, SD_SPI_CS, "sd")
	{
	}
```

Here we initialize the file system and provide the library with the SPI lines for communicating with the SD Card. The last parameter `"sd"` is the mount point. This means the SD Card is mounted at `/sd`.

## Writing to a file

Let us write a file in the SD card. We use the standard C library functions [`fopen`](http://www.cplusplus.com/reference/cstdio/fopen) and [`fwrite`](http://www.cplusplus.com/reference/cstdio/fwrite), that you might know - if you ever coded in C.

So, to write some data to a file we insert the following code in the `monoWakeFromReset` method:

```cpp
	void AppController::monoWakeFromReset()
	{
    	FILE *file = fopen("/sd/new_file.txt", "w");

    	if (file == 0) {
        	printf("Could not open write file!\r\n");
        	return;
    	}
    	else {
        	const char *str = "Hello file system!\nRemember coding in C?";
        	int written = fwrite(str, 1, strlen(str), file);
        	printf("Wrote %d bytes\r\n",written);
        	fclose(file);
    	}
	}
```

Here we open/create a file on the SD card called `new_file.txt`. The `fopen` function returns a file descriptor (`FILE*`) that is `0` if an error occurs.

If `file` is not `0` we write some text to it and finally close ([`fclose`](http://www.cplusplus.com/reference/cstdio/fclose)) the file to flush the written data to the disk. You should always close files when you are done writing to them. If you don't, you risk losing your written data.

## Reading from a file

So we just written to a file, now let us read what we just wrote. Append the following to the `monoWakeFromReset` method:

```cpp
	FILE *rFile = fopen("/sd/new_file.txt", "r");
    if (rFile == 0) {
        printf("Could not open read file!\r\n");
        return;
    }
    
    char buffer[100];
    memset(buffer, 0, 100);
    int read = fread(buffer, 1, 100, rFile);
    printf("Read %d bytes from file\r\n", read);
    printf("%s\r\n", buffer);
    fclose(rFile);
```

Here we first open the file we previously written. Then, we create a byte buffer to hold the data we read from the file. Because the initial content of `buffer` is nondeterministic, we zero its contents with the `memset` call.

```eval_rst
.. note:: We do this because ``printf`` needs a *string terminator*. A string terminator is a ``0`` character. Upon accounting a ``0`` ``printf`` will know that the end of the string has been reached.
```

The [`fread`](http://www.cplusplus.com/reference/cstdio/fread) function reads the data from the file. It reads the first 100 bytes or until [EOF](https://en.wikipedia.org/wiki/End-of-file) is reached. Then we just print the contents of buffer, which is the content of the file.

## Standard C Library

As mentioned earlier, you have access to the file I/O of `stdlib`. This means you can use the familiar stdlib file I/O API's.

These include:

* `fprintf`
* `fscanf`
* `fseek`
* `ftell`
* `fflush`
* `fgetc`
* `fputc`
* etc.

When you for example read or write from the serial port (using `printf`), you in fact just use the `stdout` and `stdin` global pointers. (`stderr` just maps to `stdout`.)

See the API for the stdlib file I/O here: [www.cplusplus.com/reference/cstdio](http://www.cplusplus.com/reference/cstdio/)

## SD Card and sleep

Currently the SD card file system library do not support sleep mode. When you wake from sleep the SD card have been reset, since its power source has been off while in sleep.

This means you cannot do any file I/O after waking from sleep. Until we fix this you need to reset Mono to re-enable file I/O.