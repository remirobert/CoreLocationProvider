//
//  CoreLocationProviderPermissionTests.swift
//  LocationTests
//
//  Created by Remi Robert on 28/01/2018.
//  Copyright © 2018 Remi Robert. All rights reserved.
//

import XCTest
import CoreLocation
import CoreLocationProvider

class CoreLocationProviderPermissionTests: XCTestCase {
    private var locationPermissionChecker: CoreLocationProvider!
    private var locationPermissionUpdateSpy: CoreLocationPermissionCheckerSpy!

    override func setUp() {
        continueAfterFailure = false

        let locationManagerMock = CLLocationManagerMock()
        locationPermissionChecker = CoreLocationProvider(locationManager: locationManagerMock)
        locationPermissionUpdateSpy = CoreLocationPermissionCheckerSpy()
    }

    override func tearDown() {
        locationPermissionChecker.unsubscribeAllPermissionUpdate()
    }

    func testCheckLocationAvalaible() {
        XCTAssertTrue(locationPermissionChecker.locationAvalaible)
    }

    func testPermissionCurrentStatus() {
        XCTAssertEqual(locationPermissionChecker.currentPermissionStatus, CLAuthorizationStatus.authorizedWhenInUse)
    }

    func testRequestAlwaysAuthorization() {
        locationPermissionChecker.subscribePermissionUpdate(object: locationPermissionUpdateSpy)
        locationPermissionChecker.requestForAuthorization(type: LocationPermissionType.alwaysAuthorization)
        XCTAssertNotNil(locationPermissionUpdateSpy.updatedStatus)
        XCTAssertEqual(locationPermissionUpdateSpy.updatedStatus!, CLAuthorizationStatus.authorizedAlways)
    }

    func testRequestWhenInUseAuthorization() {
        locationPermissionChecker.subscribePermissionUpdate(object: locationPermissionUpdateSpy)
        locationPermissionChecker.requestForAuthorization(type: LocationPermissionType.whenInUseAuthorization)
        XCTAssertNotNil(locationPermissionUpdateSpy.updatedStatus)
        XCTAssertEqual(locationPermissionUpdateSpy.updatedStatus!, CLAuthorizationStatus.authorizedWhenInUse)
    }
}

private class CoreLocationPermissionCheckerSpy: CoreLocationPermissionDelegate {
    private(set) var updatedStatus: CLAuthorizationStatus?

    func didUpdateAuthorization(status: CLAuthorizationStatus) {
        self.updatedStatus = status
    }
}
