
# Wayfinder

A pixel precise rebuild of the Apple Watch Ultra Wayfinder watchface. All assets are manually precisely redrawn.




## What it can do / running complications

 - Compass smoothly rotating 
 - GPS coordinates in center ring including last refresh time
 - Activity rings
 - Date and weekday
 - Oxygen Saturation (SpO2)
 - Altimeter / Altitude
 - Battery level
 - Distance walked of today
 - Actual BPM with range indicator for lowest and highest

## What do not work

 - Green dots for cellular signal strength since this data is noch available for me



## Installation

#### Xcode

1. Download Xcode from AppStore
2. Open Xcode and go to Settings -> Accounts and add your Apple ID
3. Go to Targets and select each of the three targets and change the "CHANGEME" part wo whatever you want (e.g. myfirstname). But make sure that you put this in every place where CHANGEME should get replaced – it must match everywhere. See screenshot here: https://ibb.co/Y81FKnq
4. Edit Info.plist file of WatchKit Extension an change the WKAppBundleIdentifier to the same. See screenshot here: https://ibb.co/DKK0D19
5. In the top toolbar select "Wayfinder WatchKit App" and as device "Apple Watch of XY via iPhone of XY" (your watch). See screenshot here: https://ibb.co/dt20Vds
6. Make sure you have all watchOS 9 addons installed – check the run toolbar on top of Xcode. If it shows "watchOS 9 (GET)" you need to download this data.
7. Hit the Run/Play button on the left side of the top toolbar and it should compile and run on your watch.
8. Check your watch and grant access for Geolocation and Health data - if something is missing check iPhone -> Settings -> Privacy -> Location or Health -> Wayfinder 

If you get compile error like Bundle Identifier not matching check that your Bundle Identifier in step 3 and 4 are matching the "CHANGEME" string.

## Language

If you like german language switch variable to "de" here: Wayfinder WatchKit Extension/WatchfaceController.swift on Line 39. Sorry, it's just hardcoded without real Localization features. Maybe provide that later.

## Donation

If you like the app – and maybe support further development – feel free to make a donation. Would appreciate that!




[![name](https://i.ibb.co/fnR0zd1/donate.png)](https://www.paypal.com/donate/?hosted_button_id=XG74YTYPGZRFL)

