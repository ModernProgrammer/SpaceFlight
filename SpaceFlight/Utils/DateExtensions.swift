//
//  DateExtensions.swift
//  SpaceFlight
//
//  Created by Diego Bustamante on 10/17/21.
//

import Foundation


extension Date {
    /// Returns a formated date value in MM/dd/yyyy
    ///
    /// - Parameters:
    ///     - dateString: The date in string format
    func getFormattedDate(dateString: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = "MM/dd/yyyy"
        let date = dateformat.date(from: dateString) ?? Date()
        return dateformat.string(from: date)
    }
}
