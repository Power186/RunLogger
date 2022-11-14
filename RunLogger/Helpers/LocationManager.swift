//
//  LocationManager.swift
//  RunLogger
//
//  Created by Scott on 7/16/21.
// 6/15 video

import Foundation
import CoreLocation

final class LocationManager {
    var manager: CLLocationManager
    
    init() {
        manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.activityType = .fitness
    }
    
    func checkLocationAuthorization() {
        if manager.authorizationStatus != .authorizedWhenInUse {
            manager.requestWhenInUseAuthorization()
            manager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "Running")
        }
    }
    
}
