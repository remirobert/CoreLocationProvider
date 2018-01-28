//
//  LocationServiceConfiguration.swift
//  LocationProvider
//
//  Created by Remi Robert on 22/01/2018.
//  Copyright © 2018 Remi Robert. All rights reserved.
//

import CoreLocation

public let fiveMinutesTimeInterval: TimeInterval = 60 * 5

public struct CoreLocationProviderConfiguration {
    public let accuracy: CLLocationAccuracy
    public let distanceFilter: CLLocationDistance
    public let activityType: CLActivityType
    public let minimumValidLocationAccuracy: CLLocationAccuracy
    public let minimumTimeInterval: TimeInterval

    public init(accuracy: CLLocationAccuracy = kCLLocationAccuracyNearestTenMeters,
                distanceFilter: CLLocationDistance = kCLDistanceFilterNone,
                activityType: CLActivityType = .other,
                minimumValidLocationAccuracy: CLLocationAccuracy = kCLLocationAccuracyThreeKilometers,
                minimumTimeInterval: TimeInterval = fiveMinutesTimeInterval) {
        self.accuracy = accuracy
        self.distanceFilter = distanceFilter
        self.activityType = activityType
        self.minimumValidLocationAccuracy = minimumValidLocationAccuracy
        self.minimumTimeInterval = minimumTimeInterval
    }
}
