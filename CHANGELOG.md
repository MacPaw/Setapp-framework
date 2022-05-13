## [Unreleased]


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
