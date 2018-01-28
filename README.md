# CoreLocationProvider

[![Build Status](https://www.bitrise.io/app/cb18c1f8eef859c0/status.svg?token=sy_NvUGoqs4gi8PyViB_Ng)](https://www.bitrise.io/app/cb18c1f8eef859c0)

A centralized location update subscription for you app.
CoreLocationProvider is a wrapper around CoreLocation's CLLocationManager giving you a centralized place to manage location updates in your app. Uses a list of subscriber to forwards the data back.

## Installation

To add CoreLocationProvider to your app, simply add **CoreLocationProvider** to your ```Podfile```.

```
target 'MyApp' do
  use_frameworks!
  pod 'CoreLocationProvider'
end
```

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

## Subscription

You can subscribe to the the location updates / permission in different places of your app. You can remove a subscription or all of them by calling the appropriete function.

Note that the subscription will be automaticcaly unsubbscribed when the object will be release. So you don't need to unsubscribe manually, or if you want to stop receiving updates.

```Swift
CoreLocationProvider.shared.subscribeLocationUpdate(object: self)
CoreLocationProvider.shared.unsubscribeLocationUpdate(object: self)
CoreLocationProvider.shared.unsubscribeAllLocationUpdate()

CoreLocationProvider.shared.subscribePermissionUpdate(object: self)
CoreLocationProvider.shared.unsubscribePermissionUpdate(object: self)
CoreLocationProvider.shared.unsubscribeAllPermissionUpdate()
```
