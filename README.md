# CoreLocationProvider

[![Build Status](https://www.bitrise.io/app/cb18c1f8eef859c0/status.svg?token=sy_NvUGoqs4gi8PyViB_Ng)](https://www.bitrise.io/app/cb18c1f8eef859c0)

A centralized location update subscription for you app.
CoreLocationProvider is a wrapper around CoreLocation's CLLocationManager giving you a centralized place to manage location updates in your app. Uses a list of subscriber to forwards the data back.

## Location Authorization Status

CoreLocationProvider can manage the location authorization status of your app. You can subscribe to it, to be informed when the authorization status is updated.

```swift
class SettingsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        CoreLocationProvider.shared.subscribePermissionUpdate(object: self)
        if CoreLocationProvider.shared.currentPermissionStatus != .authorizedWhenInUse {
            CoreLocationProvider.shared.requestForAuthorization(type: LocationPermissionType.whenInUseAuthorization)
        }
    }
}

extension SettingsViewController: CoreLocationPermissionDelegate {
    func didUpdateAuthorization(status: CLAuthorizationStatus) {
        print("status : \(status)")
    }
}
```

The CoreLocationProvider is conform to the protocol CoreLocationPermissionChecker. The role of this protocol is to provide an interface to handle the localization authorization status only. So, in your app, you can inject that small protocol, without using the whole CoreLocationProvider, and let you the possibility to mock that instance.

```swift
class SettingsViewModel {
    private let locationPermissionChecker: CoreLocationPermissionChecker

    init(locationPermissionChecker: CoreLocationPermissionChecker = CoreLocationProvider.shared) {
        self.locationPermissionChecker = locationPermissionChecker
    }
}
```

## Location updates

If your class is interested in getting location updates, it should implement the CoreLocationProviderDelegate protocol.
You need to start listening for update with **startListening**, or **startListeningSingleUpdate** for a single location.

```Swift
class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        CoreLocationProvider.shared.subscribeLocationUpdate(object: self)
        CoreLocationProvider.shared.startListening()
    }
}

extension ViewController: CoreLocationProviderDelegate {
    func didUpdateLocation(location: CLLocation) {
        print("get new location point : \(location)")
    }

    func didFailGettingLocation(error: Error) {
        print("get error : \(error.localizedDescription)")
    }
}
```

You can access to the last known location: 
```Swift
CoreLocationProvider.shared.lastKnownLocation
```
