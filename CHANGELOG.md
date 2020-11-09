## 0.0.4 (Nov 6, 2020)

### ⚠️ Breaking
* CocoaPods: to support simulators on an Apple Silicon Macs, we changed the source binary format from the fat framework to the xcframewrok. You will need CocoaPods version 1.9 or higher and Xcode version 11.0 or higher.

### New
* Apple Silicon support.

### Changed
* Removed default parameter values in the `SetappConfiguration.init` method.
* Logs: added metadata output on error.


## 0.0.3 (Jul 22, 2020)

### New
* The `SetappManager` class now has the explicit `start` method.
​
### Fixed
* In rare cases, the iOS app wasn’t activated for Setapp members even if the Framework configuration was correct and the testing went fine. The problem was related with the Framework handling responses from the Setapp system under specific circumstances. Now, in the same situations, the Framework is more stable and the app gets activated.
​
### Deprecated
* The `SetappManager.configuration` property setter has been deprecated. Use the new `start` method instead.


## 0.0.2 (Jul 10, 2020)

### Changed
* Lowered the minimum supported iOS version to 10.0 (from 10.3).
* Added more logs, so you will know that everything is OK with the Framework setup.
* Slightly improved the subscription handling process. Nothing fancy.

### Fixed
* Fixed iOS Simulator support (Swift header file 😳).


## 0.0.1 (Jun 12, 2020)

Initial release.
