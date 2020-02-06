# 🎟 Mapbox Mobile Events

[![Bitrise](https://app.bitrise.io/app/63d52d847cdb36db/status.svg?token=DDdEMfpVR8emhdGSgToskA&branch=master)](https://www.bitrise.io/app/63d52d847cdb36db)
![codecov](https://codecov.io/gh/mapbox/mapbox-events-ios/branch/master/graph/badge.svg)

The Mapbox Mobile Events SDK collects [anonymous data](https://www.mapbox.com/telemetry/) about the map and device location to continuously update and improve your maps.

### 📦 Client Frameworks

- [Mapbox Maps SDK](https://github.com/mapbox/mapbox-gl-native/)
- [Mapbox Navigation SDK](https://github.com/mapbox/mapbox-navigation-ios/)
- [Mapbox Vision SDK](https://github.com/mapbox/mapbox-vision-ios)
- [Mapbox ReactNative SDK](https://github.com/mapbox/react-native-mapbox-gl)

### 📖 Quick Start

Include `MapboxMobileEvents.framework` in your application, in the application delegate's  `…didFinishLaunching…` method, add:

```objc
MMEEventsManager *manager = [MMEventsManager.sharedManager 
    initializeWithAccessToken:@"your-mapbox-token" 
    userAgentBase:@"user-agent-string"
    hostSDKVersion:@"1.0.0"];
manager.delegate = self;
manager.isMetricsEnabledInSimulator = YES;
manager.isDebugLoggingEnabled = (DEBUG ? YES : NO);
[manager sendTurnstileEvent];
```

Or, in Swift:

```swift
let eventsManager = MMEEventsManager.sharedManager().initialize(
    withAccessToken: "your-mapbox-token", 
    userAgentBase: "user-agent-string", 
    hostSDKVersion: "1.0.0")
eventsManager.delgate = self;
eventsManager.isMetricsEnabledInSimulator = true
eventsManager.isDebugLoggingEnabled = (DEBUG ? true : false)
eventsManager.sendTurnstileEvent()
```

### 🗺 Foreground and Background Location Collection

The MapboxMobileEvents frameworks collect location data to help us improve the map. We strive to maintain a low power and network usage profile for this collection and take great care to anonymize all data in accordance with our [privacy policy](https://www.mapbox.com/legal/privacy).

The use of Mapbox SDKs and APIs on mobile devices are governed by our 
[Terms of Service](https://www.mapbox.com/legal/tos#[MomMom]) which requires your app not interfere with or limit the data that the Mapbox SDK sends to us, whether by modifying the SDK or by other means. If your application requires different terms, please contact [Mapbox Sales](https://www.mapbox.com/contact/sales/).

#### Background Location in iOS 13

If your application enables background location, the MapboxMobileEvents framework collects telemetry in the background using a passive method which allows for very low power usage. If your application does not use background location, make sure that the permissions keys for it are removed in the `Info.plist`:
`NSLocationAlwaysAndWhenInUseUsageDescription`, `NSLocationAlwaysUsageDescription`, as well as  the `UIBackgroundMode` `location`.

### ⚠️ Error and Exception Handling and Reporting

The MapboxMobileEvents frameworks strives to contain all internal exceptions and errors in an effort to prevent errors from directly 
impacting the end users of applications which use the framework. The framework will attempt to report them to our backend, 
in a redacted form, for analysis by Mapbox.

Applications and frameworks which embed `MapboxMobileEvents.framework` can implement the  `MMEEventsManagerDelegate` method:

```objc
- (void)eventsManager:(MMEEventsManager *)eventsManager 
    didEncounterError:(NSError *)error;
```

to be informed of any `NSError`s or `NSException`s the framework encounters. `NSException`s are reported wrapped in an `NSError` 
with the error code  `MMEErrorException` and the exception included in the user info dictionary under the key  `MMEErrorUnderlyingExceptionKey`.

If a framework wishes to report errors via the mobile events API two convenience methods are provided on `MMEEventsManager`:

```objc
NSError *reportableError = nil;
// make a call with an **error paramater
[MMEEventsManager.sharedManager reportError:reportableError];

@try {
    // do something dangerous
}
@catch (NSException *exceptional) {
    [MMEEventsManager.sharedManager reportException:exceptional];
}
```

### 🧪 Testing

Test cases are written using [Cedar](https://github.com/cedarbdd/cedar), to run the test in `Xcode` using `Command-U` you'll need to install the framework:

```bash
# install carthage
brew install carthage

# bootstrap the project
cd $PROJECT_DIR
carthage bootstrap
```

<style>
body { margin: 2em; max-width: 512pt; margin-right:auto; margin-left:auto; font-family: Helvetica, sans-serif; }
pre { border: 1px solid gray; padding: 1em; margin: 1em; }
</style>
