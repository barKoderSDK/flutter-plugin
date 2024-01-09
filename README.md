# How to use barkoder_flutter package in your project
### 1. Prepare environment
Install [Flutter SDK](https://docs.flutter.dev/get-started/install) and setup your environment
### 2. Add our flutter package
To add the **barkoder_flutter** package to your project, you have two options. You can either use the **barkoder_flutter** package from **pub.dev** or from a local path.

To use the package from [pub.dev](https://pub.dev/packages/barkoder_flutter), add the package name and version to your project's dependencies:
    
    
    dependencies:
        flutter:
          sdk: flutter
      
        barkoder_flutter: <package version>
    
    
If you prefer to use a local package, download the package from [https://barkoder.com](https://barkoder.com/repository) and set the package path in your project's dependencies:    
   
   ``` 
    dependencies:
          flutter:
            sdk: flutter
        
          barkoder_flutter:
            path: <package local path>
   ```
### 3. Install dependencies
Run **flutter pub get** command in terminal to install the specified dependencies in your project
### 4. Import package
Import the **barkoder_flutter** package in your project with:
   ``` 
    import 'package:barkoder_flutter/barkoder_flutter.dart';
   ```
### 5. BarkoderView
At this point the **barkoder_flutter** package is installed and imported in your project. Next step is to add the **BarkoderView** in your layout and set the **licenseKey** parameter and **onBarkoderViewCreated** callback.
   ``` 
    @override
      Widget build(BuildContext context) {
        return Scaffold(
          ...,
          body: BarkoderView(
                    licenseKey: 'KEY',
                    onBarkoderViewCreated: _onBarkoderViewCreated),
          ...
        );
   ```
   The license key is a string that concists of alphanumerical characters. See section [Section 8](#8-licensing) to learn how to get a valid license. 
### 6. Ready to Scan Event
Inside **_onBarkoderViewCreated** callback function the SDK is fully initialized and ready for configuration or to start the scanning process
   ``` 
    void _onBarkoderViewCreated(barkoder) {
      _barkoder = barkoder;

      _barkoder.setBarcodeTypeEnabled(BarcodeType.qr, true);
      _barkoder.setRegionOfInterestVisible(true);
    
      ...
    }

    void _scanPressed() {
      _barkoder.startScanning((result) {
        // The result from successful scan is received here
      });
    }
   ```
   For the complete usage of the **barkoder_flutter** plugin please check our sample.
### 7. Camera permissions
Our SDK requires camera permission to be granted in order to use scanning features. For Android, the permission is set in the manifest from the plugin. For iOS you need to specify camera permission in **Info.plist** file inside your project
   ``` 
     <key>NSCameraUsageDescription</key>
 	  <string>Camera permission</string>
   ```
### 8. Licensing 
The SDK will scan barcodes even without a valid license; however all results will be randomly masked with (*) Asterisk characters. By using our software you are agreeing to our [End User License Agreement](https://barkoder.com/EULA). To obtain a valid license, one should create an account [here](https://barkoder.com/register) and either get a trial license (to test the software out) or procure a production license that can be used within a live app.

   
   
