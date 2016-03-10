# Lightstreamer - Stock-List Demo - tvOS Client

<!-- START DESCRIPTION lightstreamer-example-stocklist-client-tvos -->

This project contains an example of application for Apple TV 4th generation that employs the Lightstreamer tvOS Client library.

![screenshot](screenshot_large.png)

## Details

This app is an Objective-C version of the [Stock-List Demos](https://github.com/Lightstreamer/Lightstreamer-example-Stocklist-client-javascript).<br>

This app uses the <b>tvOS Client API for Lightstreamer</b> to handle the communications with Lightstreamer Server. A simple user interface is implemented to display the real-time data received from Lightstreamer Server.<br>

## Install

Binaries for the application are not provided.

## Build

A full Xcode project specification, ready for compilation of the app sources, is provided. Please recall that you need a valid Apple Developer Program membership to run or debug your app on a test device.

### Getting Started

Before you can build this demo, you should complete this project with the Lighstreamer tvOS Client library. Follow these steps:

* Download the [Lightstreamer client for tvOS zip file](http://www.lightstreamer.com/repo/res/ls-tvos-client/1.0.0/ls-tvos-client-1.0.0.zip).
* Drop into the `Lightstreamer client for tvOS/lib` folder of this project the *Lightstreamer_tvOS_client.a* file from the `lib` folder of the zip file.
* Drop into the `Lightstreamer client for tvOS/include` folder of this project all the include files from the `include` folder of the zip file.

Done this, the project should compile with no errors.

### Compile and Run

A full local deploy of this app requires a Lightstreamer Server 6.0 or greater installation. Follow these steps:

* Set the IP address of your local Lightstreamer Server in the constant `PUSH_SERVER_URL`, defined in `Constants.h`; a ":port" part can also be added.
* Follow the installation instructions for the Data and Metadata adapters required by the demo, detailed in the [Lightstreamer - Basic Chat Demo - Java Adapter](https://github.com/Lightstreamer/Lightstreamer-example-Chat-adapter-java) project.

Done this, the app should run correctly on the simulator and connect to your server.

## See Also

### Lightstreamer Adapters Needed by This Demo Client

* [Lightstreamer - Stock- List Demo - Java Adapter](https://github.com/Lightstreamer/Lightstreamer-example-Stocklist-adapter-java)
* [Lightstreamer - Reusable Metadata Adapters- Java Adapter](https://github.com/Lightstreamer/Lightstreamer-example-ReusableMetadata-adapter-java)

### Related Projects

* [Lightstreamer - Stock-List Demos - HTML Clients](https://github.com/Lightstreamer/Lightstreamer-example-Stocklist-client-javascript)
* [Lightstreamer - Basic Stock-List Demo - iOS Client](https://github.com/Lightstreamer/Lightstreamer-example-StockList-client-ios)
* [Lightstreamer - Stock-List Demo with APNs Push Notifications - iOS Client](https://github.com/Lightstreamer/Lightstreamer-example-MPNStockList-client-ios)
* [Lightstreamer - Stock-List Demo - Android Client](https://github.com/Lightstreamer/Lightstreamer-example-AdvStockList-client-android)
* [Lightstreamer - Basic Stock-List Demo - Windows Phone Client](https://github.com/Lightstreamer/Lightstreamer-example-StockList-client-winphone)

## Lightstreamer Compatibility Notes

* Compatible with Lightstreamer tvOS Client Library version 1.0 or newer.
* For Lightstreamer Allegro (+ iOS Client API support), Presto, Vivace, version 6.0 or greater.
