//
//  Int+Extensions.swift
//  RunLogger
//
//  Created by Scott on 7/17/21.
//

import Foundation

extension Int {
    
    func formatTimeString() -> String {
        let hours = self / 3600
        let minutes = (self % 3600) / 60
        let seconds = (self % 3600) % 60
        
        if seconds < 0 {
            return "00:00:00"
        } else {
            if hours == 0 {
                return String(format: "%02d:%02d", minutes, seconds) // 00:00 format
            } else {
                return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            }
        }
    }
    
}
