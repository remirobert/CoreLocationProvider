//
//  CoreLocatonProviderTests.swift
//  LocationProviderTests
//
//  Created by Remi Robert on 28/01/2018.
//  Copyright © 2018 Remi Robert. All rights reserved.
//

import XCTest
import CoreLocation
import CoreLocationProvider

class CoreLocatonProviderTests: XCTestCase {
    private var locationManagerMock: CLLocationManagerMock!
    private var locationUpdateSpy: LocationUpdateSpy!
    private var coreLocationProvider: CoreLocationProvider!

    private enum LocationErrorStub: Swift.Error {
        case errorLocation
    }

    override func setUp() {
        continueAfterFailure = false

        locationManagerMock = CLLocationManagerMock()
        locationUpdateSpy = LocationUpdateSpy()
        coreLocationProvider = CoreLocationProvider(locationManager: locationManagerMock)
        coreLocationProvider.subscribeLocationUpdate(object: locationUpdateSpy)
    }

    override func tearDown() {
        coreLocationProvider.unsubscribeAllLocationUpdate()
    }

    func testListeningLocations() {
        let points = [
            CLLocation(latitude: 34, longitude: 43),
            CLLocation(latitude: 31, longitude: 47),
            CLLocation(latitude: 38, longitude: 47)
        ]

        coreLocationProvider.startListening()
        locationManagerMock.simulateNewLocations(locations: points)

        XCTAssertNil(locationUpdateSpy.error)
        XCTAssertEqual(locationUpdateSpy.locations, points)
    }

    func testListeningSingleLocations() {
        let points = [
            CLLocation(latitude: 34, longitude: 43),
            CLLocation(latitude: 31, longitude: 47),
            CLLocation(latitude: 38, longitude: 47)
        ]

        coreLocationProvider.startListeningSingleUpdate()
        locationManagerMock.simulateNewLocations(locations: points)

        XCTAssertNil(locationUpdateSpy.error)
        XCTAssertTrue(locationUpdateSpy.locations.count == 1)
        XCTAssertEqual(locationUpdateSpy.locations.first!, points.first!)
    }

    func testListeningWithError() {
        coreLocationProvider.startListening()
        locationManagerMock.simulateErrorListening(error: LocationErrorStub.errorLocation)

        XCTAssertNotNil(locationUpdateSpy.error)
        XCTAssertTrue(locationUpdateSpy.locations.isEmpty)
    }
}

private class LocationUpdateSpy: CoreLocationProviderDelegate {
    private(set) var locations = [CLLocation]()
    private(set) var error: Error?

    func didUpdateLocation(location: CLLocation) {
        locations.append(location)
    }

    func didFailGettingLocation(error: Error) {
        self.error = error
    }
}
