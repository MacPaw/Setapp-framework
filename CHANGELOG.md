## [3.2.0] - 2023-03-20

### Updated
* We fully updated a set of sample apps. They are now available for all the test cases. In particular, you can find sample apps for the iOS and macOS platforms; Swift and Objective-C languages; UIKit, AppKit, Mac Catalyst, and SwiftUI interfaces; SPM, CocoaPods, or manual integrations.
* We updated icons for sample apps so that they have dark backgrounds now.

### Fixed
* [iOS] When a user activated an iOS app, the notification on activation sometimes did not fit the screen size. We worked on layout issues and fixed them.
* [iOS] Previously we didn’t handle the blocked subscription case for iOS apps, so we couldn’t explain to users precisely why they could not activate via Setapp. Now we handle this case, and the users know they have blocked subscriptions.
* [iOS] Users with Setapp subscriptions were signed in via Setapp even after app reinstallation. We fixed this, and now they must re-activate the app.
* The Electron sample app on Apple Silicon Macs now works smoothly.
* There was an error in the Setapp Framework integration via CocoaPods, and it’s now fixed.
* Stability improvements.


## [3.1.2] - 2022-12-27

### Fixed
* [iOS] SPM warnings.
* [Electron] Error while building on Apple Silicon Macs.


## [3.1.1] - 2022-12-23

### Fixed
* [iOS] Resources bundle integration via SPM.


## [3.1.0] - 2022-12-23

### New
* [iOS] Diagnostics menu.

### Updated
* [iOS] Use app display name in activation alerts.

### Fixed
* [iOS] Public key custom name. 
* [iOS] SPM warnings.
* Xcode 13 compatibility.


## [3.0.2] - 2022-09-28

### New
* Activation link options in QR Code Generator.

### Fixed
* Fixed posiible crash when chacking if it's Setapp background session identifier. Deprecated instance method `isSetappBackgroundSessionIdentifier` and added a new class method with the same name.
* Skip running background URL session tasks when checkng SwiftUI in preview mode.
* Fixed fallback URL in QR Code Generator.


## [3.0.1] - 2022-09-12

### Fixed
* [iOS] Resources bundle destribution fix. 

## [3.0.0] - 2022-09-09

### New
* [iOS] Support activation type and fallback URL.
* [iOS] New alerts UI in iOS framework.
* License updaded

#### Boring stuff
* Migrate tests to Anka pool.
* Support of resource bundles
* Bundle distribution via SPM and Cocoapods
* Resource bundle CI build
* Fix Xcode 14 warnings and even more warnings (#SET-2167).

## [2.0.7] - 2022-09-02

### New
* [macOS] Drag and Drop QR code in QR Code Generator (e.g. to iOS Simulator).

### Fixed
* [iOS] Activation issues for various scenarios.
* [iOS] Subscription update via KVO.


## [2.0.6] - 2022-07-13

### Updated
* Rename node package from `setapp-framework` to `@setapp/framewrok-wrapper`.


## [2.0.5] - 2022-07-12

### New
* Node.js wrapper & Electron app sample.

### Updated
* [macOS] New localizations (uk, pl, nl, zh-Hans, ja, ko).

### Fixed
* [macOS] Crash when framework was trying to present an error dialog.


## [2.0.4] - 2022-06-10

### New
* Add integartion samples.

### Changed
* Catalyst API became akin to iOS API.

### Fixed
* [macOS] Setapp Desktop app search issues in rare cases.
* Cocoapods integration for Objective-C projects with macOS target lower than 10.15.


## [2.0.3] - 2022-05-13

### Changed
* Added missing part about observing Setapp Subscription changes on iOS platform to docs.
* Extended documentation of manual Setapp Framework integration steps.
* Changed default branch to `main`.

### Fixed
* Improved CocoaPods integration - no need to modify `SWIFT_INCLUDE_PATHS` anymore. 


## [2.0.2] - 2022-04-19

### Changed
* Improved CocoaPods integration - no need to modify `OTHER_LDFLAGS` anymore. 

### Fixed
* [macOS] Setapp Desktop app version recognition.
* [macOS] `showReleaseNotesWindowIfNeeded`, `showReleaseNotesWindow`, `reportUsageEvent:`, and `askUserToShareEmail` methods are now available in Objective-C.


## [2.0.1] - 2022-04-14

### New
* macOS apps support.

### Changed
* Improved license storage on iOS platform. 


## [2.0.0]

### New
* Catalyst apps support.


## [0.2.1] - 2021-05-20

### Changed
* Removed `.applicationUsageReporting` vendor authentication scope.


## [0.2.0] - 2021-05-18

### New
* New method `requestAuthorizationCode(...)`. Use it to obtain an authorization code for further communication with Vendor API. See the [docs](https://docs.setapp.com/docs/integrating-the-ios-framework#request-authorization-code-to-access-the-setapp-server) for more info and usage examples.


## [0.1.0] - 2020-12-23

### ⚠️ Breaking
This release contains some breaking API changes. See the New and Changed sections below for details. 

### New
* Added completion handlers to the `open` methods. Now, you can get a callback when the Setapp subscription state is resolved.
* Added new `viewController(for:)` method that returns a simple view controller with the result of resolving a Setapp subscription state.

### Changed
* Logs: moved log level and handles from the instance to the class level.


## [0.0.4] - 2020-11-06

### ⚠️ Breaking
* CocoaPods: To support the use of the Simulator on Macs with Apple Silicon, we’ve changed the source binary format from the universal binary (fat) framework to XCFramework. To work with the latest Framework format, you need CocoaPods version 1.9 or later and Xcode version 11.0 or later.

### New
* Apple Silicon support.

### Changed
* Removed default parameter values in the `SetappConfiguration.init` method.
* Logs: added metadata output on error.


## [0.0.3] - 2020-07-22

### New
* The `SetappManager` class now has the explicit `start` method.
​
### Fixed
* In rare cases, the iOS app wasn’t activated for Setapp members even if the Framework configuration was correct and the testing went fine. The problem was related with the Framework handling responses from the Setapp system under specific circumstances. Now, in the same situations, the Framework is more stable and the app gets activated.
​
### Deprecated
* The `SetappManager.configuration` property setter has been deprecated. Use the new `start` method instead.


## [0.0.2] - 2020-07-10

### Changed
* Lowered the minimum supported iOS version to 10.0 (from 10.3).
* Added more logs, so you will know that everything is OK with the Framework setup.
* Slightly improved the subscription handling process. Nothing fancy.

### Fixed
* Fixed iOS Simulator support (Swift header file 😳).


## [0.0.1] - 2020-06-12

Initial release.
