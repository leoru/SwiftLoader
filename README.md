# SwiftLoader
SwiftLoader is a simple and beautiful activity indicator written in Swift.

###Example
<img src="https://raw.githubusercontent.com/leoru/SwiftLoader/master/images/loadergif.gif">


## Usage

In case you installed SwiftLoader via CocoaPods you need to import it (add this somewhere at the top of your source code file):
```swift
import SwiftLoader
```

Show SwiftLoader without text:
```swift
  SwiftLoader.show(animated: true)
```

Show SwiftLoader with text: 
```swift
  SwiftLoader.show(title: "Loading...", animated: true)
```

Hide SwiftLoader:
```swift
  SwiftLoader.hide()
```

## Configuration
SwiftLoader has simple configuration system.

You need to create SwiftLoader.Config object, set params:
```swift
  var config : SwiftLoader.Config = SwiftLoader.Config()
  config.size = 150
  config.spinnerColor = .redColor()
  config.foregroundColor = .blackColor()
  config.foregroundAlpha = 0.5
```
and set new config for SwiftLoader:
```swift
  SwiftLoader.setConfig(config)
```

#### Current available params:

* size - Size of loader
* spinnerColor - Color of spinner view
* spinnerLineWidth - Line width of spinner view layer
* titleTextColor - Color of title text
* titleTextFont - Font of title text
* backgroundColor - Background color for loader
* foregroundColor - Foreground color for loader
* cornerRadius - Radius of corners of loader
* foregroundAlpha - Alpha property for foreground


## Install
SwiftSpinner is available through CocoaPods. To install it, simply add the following line to your Podfile:

```swift
pod install 'SwiftLoader'
```
NB: Currently Swift Cocoapods work only with 0.36 pre-release version. If you want to learn how to install a Swift cocoapod read more here: http://blog.cocoapods.org/Pod-Authors-Guide-to-CocoaPods-Frameworks/

In case you don’t want to use CocoaPods - just copy the file SwiftLoader/SwiftLoader.swift to your Xcode project.

### Maintainers
- [Kirill Kunst](https://github.com/leoru) ([@kirill_kunst](https://twitter.com/kirill_kunst))

## License

SwiftLoader is available under the MIT license. See the LICENSE file for more info.
