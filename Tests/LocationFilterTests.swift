//
//  LocationFilterTests.swift
//  LocationTests
//
//  Created by Remi Robert on 28/01/2018.
//  Copyright © 2018 Remi Robert. All rights reserved.
//

import XCTest
import CoreLocation
import CoreLocationProvider

class LocationFilterTests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    func testFilterWithLowAccuracy() {
        let location = CLLocation(latitude: 43, longitude: 23, horizontalAccuracy: 400)

        let configuration = CoreLocationProviderConfiguration(minimumValidLocationAccuracy: 200)
        let filter = LocationFilter(configuration: configuration)
        let result = filter.bestLocation(from: [location])

        XCTAssertNil(result)
    }

    func testFilterWithOldTimeinterval() {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: Calendar.Component.hour, value: -1, to: Date())!
        let location = CLLocation(latitude: 43, longitude: 23, horizontalAccuracy: 1, date: date)

        let configuration = CoreLocationProviderConfiguration(minimumTimeInterval: 60)
        let filter = LocationFilter(configuration: configuration)
        let result = filter.bestLocation(from: [location])

        XCTAssertNil(result)
    }

    func testWithGoodLocation() {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: Calendar.Component.minute, value: -1, to: Date())!
        let location = CLLocation(latitude: 43, longitude: 23, horizontalAccuracy: 50, date: date)

        let configuration = CoreLocationProviderConfiguration(minimumValidLocationAccuracy: 100,
                                                              minimumTimeInterval: 60 * 5)
        let filter = LocationFilter(configuration: configuration)
        let result = filter.bestLocation(from: [location])

        XCTAssertNotNil(result)
    }
}
