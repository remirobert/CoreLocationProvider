//
//  LocationFilter.swift
//  LocationProvider
//
//  Created by Remi Robert on 22/01/2018.
//  Copyright © 2018 Remi Robert. All rights reserved.
//

import CoreLocation

public protocol LocationFilterProtocol {
    func bestLocation(from locations: [CLLocation]) -> CLLocation?
}

public class LocationFilter: LocationFilterProtocol {
    private let configuration: CoreLocationProviderConfiguration

    public init(configuration: CoreLocationProviderConfiguration) {
        self.configuration = configuration
    }

    public func bestLocation(from locations: [CLLocation]) -> CLLocation? {
        guard !locations.isEmpty else { return nil }
        let newestLocation = getNewest(locations: locations)
        if newestLocation.horizontalAccuracy < configuration.minimumValidLocationAccuracy &&
            abs(newestLocation.timestamp.timeIntervalSinceNow) < configuration.minimumTimeInterval {
            return newestLocation
        }
        return nil
    }

    private func getNewest(locations: [CLLocation]) -> CLLocation {
        var newestLocation: CLLocation!
        for location in locations {
            if (newestLocation == nil ||
                location.timestamp < newestLocation.timestamp) {
                newestLocation = location
            }
        }
        return newestLocation
    }
}
