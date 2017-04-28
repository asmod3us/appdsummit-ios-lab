ECommerce-iOS
=============

Pre-Requisites
--------------
1. Xcode
2. [Cocoapods](http://cocoapods.org/): use `sudo gem install cocoapods`
3. (Optional) iOS Developer Program membership - only required to run on actual iOS devices instead of the simulator

Running with the iOS Simulator
------------------------------
1. Select an appropriate simulator target, e.g. iPhone 5s (8.0)
2. To run the application manually: select Product -> Run
3. To run the automated test simulation: select Product -> Test

Running with your own iOS Device
--------------------------------
1. For both targets ('Ecommerce Mobile Application' and 'UI Tests'), under Build Settings -> Code Signing set Code Signing Identity to use your iPhone Developer identity from the Keychain and set Provisioning Profile to 'Automatic'
2. If running on an older, pre-iOS 8.0 device: for the 'Ecommerce Mobile Application' target, under General -> Deployment Info set Deployment Target to the iOS version for your device and set Devices to 'Universal'
3. To run the application manually: select Product -> Run
4. To run the automated test simulation: select Product -> Test
