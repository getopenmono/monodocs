# Using Wifi

***Let us walk through the steps required to connect Mono to a Wifi access point, and download the content of a web page***

```eval_rst
.. note:: The network abstraction layer in *Mono Framework* is not implemented at this point. We will use the hardware layers directly, so this tutorial will be simpler in the future.
```

## The Goal

We shall create a small mono application that connects to a Wifi access point and downloads a website. To achieve this, we need to accomplish the following steps:

1. Initialize the SPI communication to te Wifi module
2. Initialize the Wifi module
3. Connect to an access point, using either hardcoded credentials or read the credentials from SD card.
4. Using DHCP to get an IP address from the access point
5. Create a HTTP Get request to a URL and display the response

## Setting up the project

First order of business is to create a new mono application project. I assume you already have installed the [developer tool chain](../getting-started/install.md).

Open a terminal (or command prompt) and fire up this command:

```
$ monomake project wifi_tutorial
```

`monomake` will now create an application project template for us. Open the two source files (*app_controller.h* and *app_controller.cpp*) in your favorite code editor. In the header file (*.h*) we need to add 2 includes, to import the wireless module definitions:

```cpp

	#include <mono.h>
	#include <wireless/module_communication.h>
	#include <wireless/redpine_module.h>

	using namespace mono;
	using namespace mono::ui;
```

Also, in the header file we need to add member variables for the module to the *AppController* class definition. Two for the SPI communication and one the HTTP client class.

```eval_rst
.. note:: The class *HttpClient* is a quick'n'dirty implementation, and is likely to be phased out to future releases of Mono Framework.
```

Therefore we extend the existing `AppController` with the class members:

```cpp

	class AppController : public mono::IApplication {
	
		// This is the text label object that will displayed
    	TextLabelView helloLabel;
    	
		// NEW CLASS MEMBERS HERE:
		
		// The hardware SPI port
    	mbed::SPI spi;
    	// The spi based communication interface for the module
    	redpine::ModuleSPICommunication spiComm;
    	
    	// The http client object variable
    	network::HttpClient client; 
    	
    	// a console view to display html data
    	mono::ui::ConsoleView<176, 110> console;
    
		// END OF NEW CLASS MEMBERS
	
	public:
    
    	AppController();
    	
    	// ...
	};
	
```

Now, we have imported the objects we are going to need, the next step is to initialize them properly.

## Initializing the Communication channel

The wifi module is connected to Mono's MCU by a dedicated SPI. In the initial release of Mono Framework there is no abstraction layer for the Wifi module, so we have to initialize this SPI explicitly.

First we need to add the raw *mbed* SPI object to the *AppController*'s constructor list. Therefore we add two new lines next to the existing initialization of *helloLabel* object:

```cpp
	
	// You should init data here, since I/O is not setup yet.
	AppController::AppController() :
    	helloLabel(Rect(0,150,176,20), "Hi, I'm Mono!"),
    	spi(RP_SPI_MOSI, RP_SPI_MISO, RP_SPI_CLK),
    	spiComm(spi, NC, RP_nRESET, RP_INTERRUPT)
	{
	// ...
	
```

So what is happening here? We are setting up two objects: the basic SPI port and a SPI based communication channel to the module (`spiComm`). The module uses a few additional hardware signals, like the reset and interrupt signals. Now we have initialized the communication to the module, so we are ready to send commands to it!

The first thing we wanna do is tell the module to boot up and begin listening for commands. But we can not do that from the constructor, because the module might not be powered yet. We need to initialize it from the `monoWakeFromReset()` method:

```cpp

	void AppController::monoWakeFromReset()
	{
		//initialize the wifi module
		redpine::Module::initialize(&spiComm);
		
		//show the console view
		console.show();

```

Now the module will boot, so next we will tell it to connect to an access point.

## Connecting to an Access Point

Let us begin with a hardcoded SSID and passphrase. (Still from inside the `monoWakeFromReset()` method.) Add this code line:

```cpp

	redpine::Module::setupWifiOnly("MY_SSID", "MY_PASSPHRASE");
	
	// print something in the console
	console.WriteLine("Connecting...");

```

Now the module will try to connect to the given access point, and expect to get a DHCP configured IP address. The `setupWifiOnly` function has a third parameter that defines the security setting. The default value is WPA/WPA2 Personal. Other supported options are: *No security*, *WEP* and *Enterprise WPA/WPA2*.

```eval_rst
.. caution:: Almost all calls to the Wifi module are *asynchronous*. This means they add commands to a queue. The function call returns immediately and the commands will be processed by the applications run loop. So when the method returns, the network is not connected and ready yet.
```

Because the connecting process is running in the background, we would like to be notified when the network is actually ready. Therefore, we need to setup a callback method. To do that we add a new method to our *AppController* class. We add the method definition in the header file:

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
		helloLabel.setText("Network Ready");
	}

```

Notice that we use the existing `helloLabel` to display the network state on the screen. 

Now, we need to tell the module to call our method, when the network is connected. We append this line to `monoWakeFromReset()`:

```cpp

	redpine::Module::setNetworkReadyCallback<AppController>(this, &AppController::networkReadyHandler);

```

This sets up the callback function, such that the module will call the `networkReadyHandler()` method, on our *AppController* instance.

```eval_rst
.. tip:: Callback functions are an important part of using the network on Mono. If you wish to familiarize yourself with the concept, please see the in-depth article: *Queued callbacks and interrupts*
```

If you feel for it, tryout the code we have written so far. If you monitor the serial port, you should see the Wifi module emitting debug information. Hopefully you should see the *Network Ready* text in screen after ~20 secs. If not, consult the serial terminal for any clue to what went wrong.

## Download a website

Now that we have connected to an access point with DHCP, I take the freedom to assume that Mono now has internet access! So lets go ahead and download: this webpage!

To download a website means doing a `HTTP GET` request from a HTTP client, and here our `HttpClient` class member from earlier, comes into action.

Like the process of connecting to an access point was asynchrounous, (happening in the background), the process of downloading websites is asynchrounous. That means we are going to need another callback function, so lets define another method on *AppController.h*:

```cpp
	
	// ...
	
	public:
	
		void networkReadyHandler();
		
		void httpHandleData(const network::HttpClient::HttpResponseData &data);
		
	// ...
```

Notice the ampersand (`&`) symbol that define the `data` parameter as a reference. In the implementation file we add the function body:

```cpp

	void AppController::httpHandleData(const network::HttpClient::HttpResponseData &data)
	{
		helloLabel.setText("loading");
		console.WriteLine(data.bodyChunk);
		
		if (data.Finished)
		{
			helloLabel.setText("Downloaded");
		}
	}

```

HttpClient will return the HTML content in multiple calls, and you use the `Finished` member to see when all data has arrived. Here we just set the label content to the HTML chunk, so it is not so pretty to look at. When the response has been downloaded, we set the text label to display *Downloaded*.

Now, we are ready to setup the http client and fetch the webpage. We can use HttpClient only after the network is ready. So in the implementation file, add this to `networkReadyHandler()`:

```cpp

	void AppController::networkReadyHandler()
	{
		helloLabel.setText("Network Ready");
		
		//fetch a webpage
		client = mono::network::HttpClient("http://developer.openmono.com/en/latest/");
		
		//now the client will be fetching the web page
		// let setup the data callback
		client.setDataReadyCallback<AppController>(this, &AppController::httpHandleData);
	}

```