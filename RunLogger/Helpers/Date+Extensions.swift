//
//  Date+Extensions.swift
//  RunLogger
//
//  Created by Scott on 7/20/21.
//

import Foundation

extension Date {
    
    func getDateString() -> String {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: self)
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        
        return "\(month)/\(day)/\(year)"
    }
    
}
