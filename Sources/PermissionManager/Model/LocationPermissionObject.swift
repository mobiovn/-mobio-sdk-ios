//
//  LocationPermissionObject.swift
//  PermissionApp
//
//  Created by Sun on 08/09/2022.
//

import MapKit

@available(iOSApplicationExtension, unavailable)
class LocationPermissionObject: NSObject, PermissionObject {
    
    var permissionHandler: VoidHandler?
    var name: String = "Location"
    var summany: String = "Allow to acces your location"
    var emptyImage: String = "location_empty"
    var fullImage: String = "location_full"
    
    let locationManager = CLLocationManager()
    
    override init() {
        super.init()
    }
    
    func checkStatus(handler: @escaping (PermissionStatus) -> Void) {
        let status = locationManager.authorizationStatus
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            handler(.allowed)
        } else {
            handler(.notAllow)
        }
    }
    
    func requestPermission() {
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
    }
}

@available(iOSApplicationExtension, unavailable)
extension LocationPermissionObject: CLLocationManagerDelegate {
    
    func locationManager (_ manager: CLLocationManager,
                          didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied {
            permissionHandler?(.notAllow)
        } else {
            permissionHandler?(.allowed)
        }
    }
}
