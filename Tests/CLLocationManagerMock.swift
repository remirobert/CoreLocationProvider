//
//  CLLocationManagerMock.swift
//  LocationProviderTests
//
//  Created by Remi Robert on 28/01/2018.
//  Copyright © 2018 Remi Robert. All rights reserved.
//

import CoreLocation

public class CLLocationManagerMock: CLLocationManager {
    public func simulateNewLocations(locations: [CLLocation]) {
        locations.forEach {
            self.delegate?.locationManager?(self, didUpdateLocations: [$0])
        }
    }

    public func simulateErrorListening(error: Error) {
        self.delegate?.locationManager?(self, didFailWithError: error)
    }
}

public extension CLLocationManagerMock {
    override static func locationServicesEnabled() -> Bool {
        return true
    }

    override static func authorizationStatus() -> CLAuthorizationStatus {
        return CLAuthorizationStatus.authorizedWhenInUse
    }

    override func requestAlwaysAuthorization() {
        delegate?.locationManager?(self, didChangeAuthorization: .authorizedAlways)
    }

    override func requestWhenInUseAuthorization() {
        delegate?.locationManager?(self, didChangeAuthorization: .authorizedWhenInUse)
    }
}

