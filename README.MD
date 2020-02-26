# aiDee

> **aiDee** *(/ɪd/)*, *noun*
>
> "... abbreviation for identification: any official card or document with your name and photograph or other information on it that you use to prove who you are."


## iOS Biometrics Micro-Framework

aiDee is a Swift micro-framework that can be used to authenticate with iOS Devices using biometrics: Touch ID or Face ID.
Written in Swift this aims to be a simple example of Apple's not-so-new [LocalAuthentication](https://developer.apple.com/documentation/localauthentication) API usage. 

[![Platform](https://img.shields.io/cocoapods/p/aiDee.svg?style=flat)](http://cocoapods.org/pods/aiDee)
[![Swift](https://img.shields.io/badge/swift-5.1-orange.svg)](https://cocoapods.org/pods/aiDee)
[![CocoaPods](https://img.shields.io/cocoapods/v/aiDee.svg)](https://cocoapods.org/pods/aiDee)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![SPM](https://img.shields.io/badge/swift%20package%20manager-compatible-green.svg)](https://github.com/aiFigueiredo/aiDee/)
[![apm](https://img.shields.io/apm/l/vim-mode.svg)](https://github.com/aiFigueiredo/aiDee/blob/master/LICENSE)


## Requirements

Xcode 11, iOS 11.0


## Get Started

As a first step you should add an entry on your `Info.plist` file for key `NSFaceIDUsageDescription`.

The value should be a string describing the reason why your app uses Touch or Face ID. More information on this subject can be found on [Apple's](https://developer.apple.com/documentation/localauthentication/logging_a_user_into_your_app_with_face_id_or_touch_id) [Documentation](https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html#//apple_ref/doc/uid/TP40009251-SW75).


## Installation

### Cocoapods

aiDee is available through [CocoaPods](https://cocoapods.org/pods/aiDee). 
Just add the following line to your PodFile:

```swift
pod 'aiDee'
```
And then run the following command on the terminal:

```swift
pod install
```

### Carthage
Add the entry to your Cartfile:

```swift
github "aiFigueiredo/aiDee"
```

And then run the following command on the terminal:

```swift
carthage update
```


## Usage

```swift
import aiDee
...

// Instantiate BiometricAuthentication object
let biometricAuth = BiometricAuthentication()

// Get Biometric Availability Information

let biometricsAvailable: Bool = biometricAuth.isBiometricsAvailable()
let biometricsType: BiometricType = biometricAuth.biometricType() // .touchId / .faceId / .none

// Authenticate using Biometrics providing a LocalizedString with a reason for the request

biometricAuth.authenticateUser(localizedReason: "Reason for Biometric request") { [weak self] result in
    switch result {
        case .success: self?.showAlert(title: "Success", message: "Biometric Auth Successful")
        case .failure(let error): self?.showAlert(title: "Error", message: error.errorDescription)
    }
}
```


## Useful Tips
- Both FaceID and TouchID can be tested in the simulator by selecting "Hardware" > "TouchID"/"FaceID" > "Enrolled"
- This micro framework should be used alongside the use of Keychain to store sensitive information.


## Contributing

Feel free to contribute to this project by opening  [issues](https://github.com/aiFigueiredo/aiDee/issues?q=is%3Aissue+is%3Aopen+sort%3Aupdated-desc) or opening [pull requests](https://github.com/aiFigueiredo/aiDee/pulls?q=is%3Apr+is%3Aopen+sort%3Aupdated-desc).


## License

aiDee's available under the MIT license. See the [LICENSE](https://github.com/aiFigueiredo/aiDee/blob/master/LICENSE) file for more information.
