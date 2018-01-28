//
//  CLLocation+Init.swift
//  LocationTests
//
//  Created by Remi Robert on 28/01/2018.
//  Copyright © 2018 Remi Robert. All rights reserved.
//

import CoreLocation

extension CLLocation {
    convenience init(latitude: Double,
                     longitude: Double,
                     horizontalAccuracy: Double = 200,
                     date: Date = Date()) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude,
                                                longitude: longitude)
        self.init(coordinate: coordinate,
                  altitude: 20,
                  horizontalAccuracy: horizontalAccuracy,
                  verticalAccuracy: 200,
                  course: 20,
                  speed: 0,
                  timestamp: date)
    }
}
