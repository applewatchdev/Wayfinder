# Wayfinder

A pixel-perfect recreation of the Apple Watch Ultra Wayfinder watch face. All assets have been meticulously and manually redrawn.

![Preview](https://preview.redd.it/xp46rmkm2wn91.jpg?width=640&crop=smart&auto=webp&v=enabled&s=b981d62c5ebb2b3fd61c8c2b15102bc991728261)

## Features and Complications

- Smoothly rotating compass
- GPS coordinates displayed in the center ring, including the last refresh time
- Activity rings
- Date and weekday
- Oxygen saturation (SpO2)
- Altimeter/altitude
- Battery level
- Distance walked today
- Current BPM with range indicator for lowest and highest

## Limitations

 - Green dots for cellular signal strength

## Installation

### Xcode

1. Download *Xcode* from the App Store
2. Open *Xcode*, navigate to *Settings* -> *Accounts* and add your Apple ID
3. Go to *Targets*, select each of the three targets, and replace the `CHANGEME` part with your preferred text (e.g., your first name). Ensure the same text is used in all instances of `CHANGEME.`
![Step3](https://i.ibb.co/6bT7p9f/targets.jpg)
4. Edit the `Info.plist` file of the WatchKit Extension and change the `WKAppBundleIdentifier` to match the text from step 3.
![Step4](https://i.ibb.co/tCCVMHq/info.jpg)
5. In the top toolbar, select *Wayfinder WatchKit App* and choose *Apple Watch of XY via iPhone of XY* (your watch) as the device.
![Step5](https://i.ibb.co/pQzvMt6/Bildschirmfoto-2022-09-24-um-20-14-22.png)
6. Ensure all watchOS 9 add-ons are installed. Check the run toolbar at the top of Xcode. If it shows `watchOS 9 (GET)`, you need to download the required data.
7. Press the *Run/Play button* on the left side of the top toolbar to compile and run the app on your watch.
8. Check your watch and grant access to *Geolocation* and *Health* data. If any permissions are missing, check *iPhone* -> *Settings* -> *Privacy* -> *Location or Health* -> *Wayfinder*.

If you encounter a compile error related to the *Bundle Identifier* not matching, ensure that your *Bundle Identifier* in steps 3 and 4 matches the `CHANGEME` string.

## Language

To switch to the German language, change the variable to `de` in *Wayfinder WatchKit Extension* / `WatchfaceController.swift` on Line 39. Currently, localization is hardcoded and not fully implemented. This may be improved in a future update.

## Donations

If you enjoy the app and would like to support further development, consider making a donation. Your support is appreciated!

[![name](https://i.ibb.co/fnR0zd1/donate.png)](https://www.paypal.com/donate/?hosted_button_id=XG74YTYPGZRFL)

