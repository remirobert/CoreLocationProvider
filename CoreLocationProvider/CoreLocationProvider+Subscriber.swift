//
//  CoreLocationProvider+Subscriber.swift
//  LocationProvider
//
//  Created by Remi Robert on 22/01/2018.
//  Copyright © 2018 Remi Robert. All rights reserved.
//

import CoreLocation

class WeakRef<T> {
    private weak var internalValue: AnyObject?

    var value: T? {
        get {
            return internalValue as? T
        }
    }

    init?(value: T?) {
        guard let value = value else {
            return nil
        }
        self.internalValue = value as AnyObject
    }
}

class MutlicastDelegate<T: AnyObject> {
    private var refs = [WeakRef<T>]()
    var delegates: [T] {
        clearNilRefs()
        return refs.flatMap({ $0.value })
    }

    func addDelegate(object: T) {
        guard let ref = WeakRef<T>(value: object) else { return }
        refs.append(ref)
    }

    func remove(object: T) {
        let index = refs.index {
            $0.value === object
        }
        guard let indexRef = index else { return }
        refs.remove(at: indexRef)
    }

    func removeAll() {
        refs.removeAll()
    }

    func clearNilRefs() {
        for (index, element) in refs.enumerated().reversed() {
            if element.value == nil {
                refs.remove(at: index)
            }
        }
    }
}

extension CoreLocationProvider {
    internal func broadcastNewLocation(location: CLLocation) {
        locationUpdateMutlicast.delegates.forEach {
            $0.didUpdateLocation(location: location)
        }
    }

    internal func broadcastError(error: Error) {
        locationUpdateMutlicast.delegates.forEach {
            $0.didFailGettingLocation?(error: error)
        }
    }

    public func subscribeLocationUpdate(object: CoreLocationProviderDelegate) {
        locationUpdateMutlicast.addDelegate(object: object)
    }

    public func unsubscribeLocationUpdate(object: CoreLocationProviderDelegate) {
        locationUpdateMutlicast.remove(object: object)
    }

    public func unsubscribeAllLocationUpdate() {
        locationUpdateMutlicast.removeAll()
    }
}

extension CoreLocationProvider {
    internal func broadcastPermissionUpdate(status: CLAuthorizationStatus) {
        permissionUpdateMutlicast.delegates.forEach {
            $0.didUpdateAuthorization(status: status)
        }
    }
    
    public func subscribePermissionUpdate(object: CoreLocationPermissionDelegate) {
        permissionUpdateMutlicast.addDelegate(object: object)
    }

    public func unsubscribePermissionUpdate(object: CoreLocationPermissionDelegate) {
        permissionUpdateMutlicast.remove(object: object)
    }

    public func unsubscribeAllPermissionUpdate() {
        permissionUpdateMutlicast.removeAll()
    }
}
