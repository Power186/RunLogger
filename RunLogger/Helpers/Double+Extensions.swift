//
//  Double+Extensions.swift
//  RunLogger
//
//  Created by Scott on 7/17/21.
//

import Foundation

extension Double {
    
    func meterToMiles() -> Double {
        let meters = Measurement(value: self, unit: UnitLength.meters)
        return meters.converted(to: .miles).value
    }
    
    func toString(places: Int) -> String {
        return String(format: "%.\(places)f", self)
    }
    
}
