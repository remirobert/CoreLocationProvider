//
//  LocationProvider.swift
//  LocationProvider
//
//  Created by Remi Robert on 22/01/2018.
//  Copyright © 2018 Remi Robert. All rights reserved.
//

import CoreLocation

@objc public protocol CoreLocationProviderDelegate: AnyObject {
    func didUpdateLocation(location: CLLocation)
    @objc optional func didFailGettingLocation(error: Error)
}

@objc public protocol CoreLocationPermissionDelegate: AnyObject {
    func didUpdateAuthorization(status: CLAuthorizationStatus)
}

public class CoreLocationProvider: NSObject {
    internal let locationManager: CLLocationManager
    private let locationFilter: LocationFilterProtocol
    private var singleUpdate = false

    internal let locationUpdateMutlicast = MutlicastDelegate<CoreLocationProviderDelegate>()
    internal let permissionUpdateMutlicast = MutlicastDelegate<CoreLocationPermissionDelegate>()

    private var lastLocation: CLLocation?
    public var lastKnownLocation: CLLocation? {
        guard let lastKnownLocation = lastLocation else { return nil }
        return locationFilter.bestLocation(from: [lastKnownLocation])
    }

    static var shared = CoreLocationProvider()

    var configuration: CoreLocationProviderConfiguration {
        didSet {
            setupLocationManager()
        }
    }

    public convenience init(locationManager: CLLocationManager = CLLocationManager(),
                            locationFilter: LocationFilterProtocol =
        LocationFilter(configuration: CoreLocationProviderConfiguration())) {
        self.init(locationManager: locationManager,
                  configuration: CoreLocationProviderConfiguration(),
                  locationFilter: locationFilter)
    }

    public init(locationManager: CLLocationManager,
                configuration: CoreLocationProviderConfiguration,
                locationFilter: LocationFilterProtocol) {
        self.locationManager = locationManager
        self.configuration = configuration
        self.locationFilter = locationFilter
        self.lastLocation = locationManager.location
        super.init()
        setupLocationManager()
    }

    private func setupLocationManager() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = configuration.accuracy
        self.locationManager.activityType = configuration.activityType
        self.locationManager.distanceFilter = configuration.distanceFilter
    }
}

extension CoreLocationProvider {
    public func startListening() {
        singleUpdate = false
        locationManager.startUpdatingLocation()
    }

    public func startListeningSingleUpdate() {
        startListening()
        singleUpdate = true
    }

    public func stopListening() {
        locationManager.stopUpdatingLocation()
    }
}

extension CoreLocationProvider: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager,
                                didUpdateLocations locations: [CLLocation]) {
        if singleUpdate {
            stopListening()
        }
        guard let location = locationFilter.bestLocation(from: locations) else { return }
        broadcastNewLocation(location: location)
        lastLocation = location
    }

    public func locationManager(_ manager: CLLocationManager,
                                didFailWithError error: Error) {
        broadcastError(error: error)
    }
}

