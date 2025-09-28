//
//  Date+Extension.swift
//  BeReal
//
//  Created by Abhijeet Cherungottil on 9/27/25.
//

import UIKit

extension Date {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        
        if secondsAgo < minute {
            return "\(secondsAgo) sec ago"
        } else if secondsAgo < hour {
            return "\(secondsAgo / minute) min ago"
        } else if secondsAgo < day {
            return "\(secondsAgo / hour) hour ago"
        } else if secondsAgo < (day * 7) {
            let days = secondsAgo / day
            return days == 1 ? "1 day ago" : "\(days) days ago"
        } else {
            // fallback to formatted date
            return DateFormatter.postFormatter.string(from: self)
        }
    }
}

extension DateFormatter {
    static var postFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
}
