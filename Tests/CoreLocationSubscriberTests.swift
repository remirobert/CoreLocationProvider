//
//  CoreLocationSubscriberTests.swift
//  LocationTests
//
//  Created by Remi Robert on 28/01/2018.
//  Copyright © 2018 Remi Robert. All rights reserved.
//

import XCTest
import CoreLocation
import CoreLocationProvider

class CoreLocationSubscriberTests: XCTestCase {
    private var locationManagerMock: CLLocationManagerMock!
    private var coreLocationProvider: CoreLocationProvider!

    override func setUp() {
        continueAfterFailure = false

        locationManagerMock = CLLocationManagerMock()
        coreLocationProvider = CoreLocationProvider(locationManager: locationManagerMock)
    }

    override func tearDown() {
        coreLocationProvider.unsubscribeAllLocationUpdate()
        coreLocationProvider.unsubscribeAllPermissionUpdate()
    }

    func testMultipleSubsriber() {
        let subscriber1 = SubscriberSpy()
        let subscriber2 = SubscriberSpy()

        coreLocationProvider.subscribeLocationUpdate(object: subscriber1)
        coreLocationProvider.subscribeLocationUpdate(object: subscriber2)

        coreLocationProvider.startListening()

        locationManagerMock.simulateNewLocations(locations: [CLLocation(latitude: 32, longitude: 45)])

        XCTAssertTrue(subscriber1.updateLocationCalled)
        XCTAssertTrue(subscriber2.updateLocationCalled)
    }

    func testRemoveSubscriber() {
        let subscriber1 = SubscriberSpy()
        let subscriber2 = SubscriberSpy()

        coreLocationProvider.subscribeLocationUpdate(object: subscriber1)
        coreLocationProvider.subscribeLocationUpdate(object: subscriber2)
        coreLocationProvider.unsubscribeLocationUpdate(object: subscriber2)

        coreLocationProvider.startListening()

        locationManagerMock.simulateNewLocations(locations: [CLLocation(latitude: 32, longitude: 45)])

        XCTAssertTrue(subscriber1.updateLocationCalled)
        XCTAssertFalse(subscriber2.updateLocationCalled)
    }

    func testRemoveAllSubscriber() {
        let subscriber1 = SubscriberSpy()
        let subscriber2 = SubscriberSpy()

        coreLocationProvider.subscribeLocationUpdate(object: subscriber1)
        coreLocationProvider.subscribeLocationUpdate(object: subscriber2)
        coreLocationProvider.unsubscribeAllLocationUpdate()

        coreLocationProvider.startListening()

        locationManagerMock.simulateNewLocations(locations: [CLLocation(latitude: 32, longitude: 45)])

        XCTAssertFalse(subscriber1.updateLocationCalled)
        XCTAssertFalse(subscriber2.updateLocationCalled)
    }
}

private class SubscriberSpy: CoreLocationProviderDelegate, CoreLocationPermissionDelegate {
    private(set) var updateLocationCalled = false
    private(set) var failGettingLocationCalled = false
    private(set) var updateAuthorizationCalled = false

    func didUpdateLocation(location: CLLocation) {
        updateLocationCalled = true
    }

    func didFailGettingLocation(error: Error) {
        failGettingLocationCalled = true
    }

    func didUpdateAuthorization(status: CLAuthorizationStatus) {
        updateAuthorizationCalled = true
    }
}
