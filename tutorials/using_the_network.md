# Using Wifi

***Let us walk through the steps required to connect Mono to a Wifi access point, and download the content of a web page***

## The Goal

We shall create a small mono application that connects to a Wifi access point and downloads a website. To achieve this, we need to accomplish the following steps:

1. Initialize the Wifi module
1. Connect to an access point, using hardcoded credentials
1. Create a HTTP Get request to a URL and display the response

## Setting up the project

First order of business is to create a new mono application project. I assume you already have installed the [OpenMono SDK](../getting-started/install.md).

Open a terminal (or command prompt) and fire up this command:

```
$ monomake project --bare wifi_tutorial
```

`monomake` will now create an application project template for us. Open the two source files (*app_controller.h* and *app_controller.cpp*) in your favorite code editor. In the header file (*.h*) we need to an include, to import the wireless module definitions:

```cpp

	#include <mono.h>
	#include <io/wifi.h>

	using namespace mono;
	using namespace mono::ui;
```

Also, in the header file we need to add member variables for the module to the *AppController* class definition.

```eval_rst
.. note:: The class *HttpClient* is a quick'n'dirty implementation, and is likely to be phased out to future releases of Mono Framework.
```

Therefore we extend the existing `AppController` with the class members:

```cpp

	class AppController : public mono::IApplication {
		
		// The wifi hardware class
		io::Wifi wifi;
    	
    	// The http client
    	network::HttpClient client; 
    	
    	// a console view to display html data
    	ConsoleView<176, 220> console;
	
	public:
    
    	AppController();
    	
    	// ...
	};
	
```

Now, we have imported the objects we are going to need, the next step is to initialize them properly.

## Initializing the Wifi and connecting

We need to supply our Wifi's *SSID* (access point's name) and passphrase to the `Wifi` object. These are passed in the *constructor*:

```cpp
	
	// You should init data here, since I/O is not setup yet.
	AppController::AppController() :
    	wifi("MY_SSID", "MY_PASSPHRASE")
	{
	// ...
	
```

Next we want to connect to our access point, using the credential we just provided. So far the hardware Wifi module is not connected or initialized. This happens when we call the method `connect` on `Wifi`. We cannot do that from the constructor, but only from the method `monoWakeFromReset`:

```cpp

	void AppController::monoWakeFromReset()
	{
		//show our console view
		console.show();

		//connect the wifi module
		wifi.connect();

		//tell the world what we are doing
		console.WriteLine("Connecting...");
```

The module will try to connect to the given access point, and expect to get a DHCP configured IP address.

The constructor on `Wifi` actually had a third optional parameter that can define the security setting. The default value is WPA/WPA2 Personal. Other supported options are: *No security*, *WEP* and *Enterprise WPA/WPA2*.

```eval_rst
.. caution:: Almost all calls to the Wifi module are *asynchronous*. This means they add commands to a queue. The function call returns immediately and the commands will be processed by the applications run-loop. So when the method returns, the network is not connected and ready yet.
```

Because the connect process is running in the background, we would like to be notified when the network is actually ready. Therefore, we need to setup a callback method. To do that we add a new method to our *AppController* class. We add the method definition in the header file:

```cpp

	class AppController : public mono::IApplication
	{
	// ...
	
	public:
	
		void networkReadyHandler();
	
	// ...
```

Next, we add the method body in the implementation (*.cpp*) file:

```cpp
	void AppController::networkReadyHandler()
	{
		console.WriteLine("Network ready");
	}
```

Now, we need to tell the `wifi` object to call our method, when the network is connected. We append this line to `monoWakeFromReset()`:

```cpp
	wifi.setConnectedCallback(this, &AppController::networkReadyHandler);
```

This sets up the callback function, such that the module will call the `networkReadyHandler()` method, on our *AppController* instance.

<!-- 
```eval_rst
.. tip:: Callback functions are an important part of using the network on Mono. If you wish to familiarize yourself with the concept, please see the in-depth article: *Queued callbacks and interrupts*
```
-->

If you feel for it, tryout the code we have written so far. If you monitor the serial port, you should see the Wifi module emitting debug information. Hopefully you should see the *Network Ready* text in screen after ~20 secs. If not, consult the serial terminal for any clue to what went wrong.

```eval_rst
.. caution:: We have not set any error handler callback function. You should alway do that, because failing to connect to an access point is a pretty common scenario. See the API reference for `Wifi <../reference/mono_io_IWifi.html>`_.
```

## Download a website

Now that we have connected to an access point with DHCP, I take the freedom to assume that your Mono now has internet access! So lets go ahead and download: this webpage!

To download a website means doing a `HTTP GET` request from a HTTP client, and here our `HttpClient` class member from earlier, comes into action.

Like the process of connecting to an access point was asynchrounous, (happening in the background), the process of downloading websites is asynchrounous. That means we are going to need another callback function, so lets define another method on *AppController.h*:

```cpp
	
	// ...
	
	public:
	
		void networkReadyHandler();
		
		void httpHandleData(const network::HttpClient::HttpResponseData &data);
		
	// ...
```

Notice the ampersand (`&`) symbol that defines the `data` parameter as a reference.

```eval_rst
.. note:: If you what to know more about references in C++, I recommend our article: `The C programmers guide to C++ <../articles/c-program-guide-cpp.html>`_.
```

In the implementation file (*app_controller.cpp*) we add the function body:

```cpp

	void AppController::httpHandleData(const network::HttpClient::HttpResponseData &data)
	{
		console.WriteLine(data.bodyChunk);
		
		if (data.Finished)
		{
			console.WriteLine("All Downloaded");
		}
	}

```

`HttpClient` will return the HTML content in multiple calls, and you use the `Finished` member to see when all data has arrived. Here we just append the HTML chunk to the console, so it is not too pretty to look at. When the response has been downloaded, we append the text *All Downloaded*.

Now, we are ready to setup the http client and fetch the webpage. We can use HttpClient *only after* the network is ready. So in the implementation file, add this to `networkReadyHandler()`:

```cpp

	void AppController::networkReadyHandler()
	{
		console.WriteLine("Network ready");
		
		//fetch a webpage
		client = mono::network::HttpClient("http://developer.openmono.com/en/latest/");
		
		//now the client will be fetching the web page
		// let setup the data callback
		client.setDataReadyCallback(this, &AppController::httpHandleData);
	}

```

Go ahead and build the app. Upload to Mono and see the HTML content scroll across the display.