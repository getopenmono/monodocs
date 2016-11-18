# Lets start: Installing Mono Framework

***In this guide we go through the steps of installing the Mono toolchain on your computer.***

## Download

First we begin with downloading the installer package, that will install the framework on your computer:

<table class="table wy-text-center" style="width: 100%;">
<tr><th>Windows</th><th>macOS</th><th>Linux (Debian)</th></tr>
<tr>
<td><a href="https://github.com/getopenmono/openmono_package/releases/download/SDKv1_4/OpenMonoSetup-v1.4.1.exe" class="btn btn-neutral"><span class="fa fa-download"></span> Download </a> </td>
<td><a href="https://github.com/getopenmono/openmono_package/releases/download/SDKv1_4/OpenMono-v1.4.1-Mac.pkg" class="btn btn-neutral"><span class="fa fa-download"></span> Download</a></td>
<td><a href="https://github.com/getopenmono/openmono_package/releases/tag/SDKv1_4" class="btn btn-neutral" target="_blank"><span class="fa fa-download"></span> Download</a></td>
</tr>
</table>
<br/>

Download the installer package that fits your OS. Run the installer and follow the steps to install Mono's developing tools on your system.

The installer contains all you need to install apps on mono, and to develop your own apps. The installer package contains:

 * **Mono Framework code**: The software library
 * **GCC for embedded ARM**: Compiler
 * **Binutils** (Windows only): The `make` tool
 * **monoprog**: Tool that uploads apps to Mono via USB
 * **monomake**: Tool that creates new mono application projects for you

## Check installation

When the installer package has finished, you should check that have the toolchain installed. Open a terminal:

### Mac & Linux

Open the *Terminal* application, and type this into it:

```
	$ monomake
```

If you have installed the toolchain successfully in your path, the `monomake` tool should respond this:

```
	ERR: No command argument given! You must provide a command
	Usage:
	monomake COMMAND [options]
	Commands:
	  project [name]  Create a new project folder. Default name is: new_mono_project
	  version         Display the current version of monomake
	  path            Display the path to the Mono Environment installation dir
```

Congratulations, you have the tool chain running! Now, you are ready to crate your first *Hello World* project in the next tutorial.

#### Any problems?

If you do not get the excepted response, but instead something like:

```
-bash: monomake: command not found
```

It means `monomake` is not in your `PATH`. Check if you can see a mono reference in your `PATH`, by typing:

```
	$ echo $PATH
```

Look for references to something like `/usr/local/openmono/bin`. If you cannot find this, please restart the *Terminal* application to reload bash profile.

### Windows

Open the Run command window (press Windows-key + R), type `cmd` and press Enter. The *Command Prompt* window should open. Check that the toolchain is correctly installed by typing:

```
	Microsoft Windows [Version 6.3.9600]
	(c) 2013 Microsoft Corporation. All rights reserved.

	C:\Users\stoffer> monomake
```

Like on Mac and Linux, `monomake` should respond with:

```
	ERR: No command argument given! You must provide a command
	Usage:
	monomake COMMAND [options]
	Commands:
	  project [name]  Create a new project folder. Default name is: new_mono_project
	  version         Display the current version of monomake
	  path            Display the path to the Mono Environment installation dir
```

If you get this: Congratulations! You have the toolchain installed, and you can go ahead with creating your first *Hello World* app, in the next tutorial.

#### Any problems?

On the other hand, if you get:

```
	'monomake' is not recognized as an internal or external command,
	operable program or batch file.
```

It means `monomake` is not in the environment variable `PATH`. Check that you really did install the tool chain, and that your system environment variable `PATH` does indeed contain a path like this:

```
C:\Program Files\OpenMono\bin
```

You can see your `PATH` environment variable by typing:

```
	C:\Users\stoffer> echo %PATH%
```
