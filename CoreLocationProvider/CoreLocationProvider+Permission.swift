//
//  CoreLocationProvider+Permission.swift
//  LocationProvider
//
//  Created by Remi Robert on 22/01/2018.
//  Copyright © 2018 Remi Robert. All rights reserved.
//

import CoreLocation

public enum LocationPermissionType {
    case whenInUseAuthorization
    case alwaysAuthorization
}

public protocol CoreLocationPermissionChecker {
    typealias CompletionHandler = ((CLAuthorizationStatus) -> Void)
    var locationAvalaible: Bool { get }
    var currentPermissionStatus: CLAuthorizationStatus { get }
    func requestForAuthorization(type: LocationPermissionType)
}

extension CoreLocationProvider: CoreLocationPermissionChecker {
    public var locationAvalaible: Bool {
        return type(of: locationManager).locationServicesEnabled()
    }

    public var currentPermissionStatus: CLAuthorizationStatus {
        return type(of: locationManager).authorizationStatus()
    }

    public func requestForAuthorization(type: LocationPermissionType) {
        switch type {
        case .alwaysAuthorization:
            locationManager.requestAlwaysAuthorization()
        case .whenInUseAuthorization:
            locationManager.requestWhenInUseAuthorization()
        }
    }

    public func locationManager(_ manager: CLLocationManager,
                                didChangeAuthorization status: CLAuthorizationStatus) {
        broadcastPermissionUpdate(status: status)
    }
}
