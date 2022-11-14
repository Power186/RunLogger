//
//  Location.swift
//  RunLogger
//
//  Created by Scott on 7/19/21.
//

import Foundation
import RealmSwift

public final class Location: Object {
    
    @objc dynamic public private(set) var latitude = 0.0
    @objc dynamic public private(set) var longitude = 0.0
    
    convenience init(lat: Double, long: Double) {
        self.init()
        self.latitude = lat
        self.longitude = long
    }
}
