//
//  DateExtensions.swift
//  SpaceFlight
//
//  Created by Diego Bustamante on 10/17/21.
//

import Foundation

extension Date {
    /// Gets a string date and formats it
    /// - Parameter dateString: The string represenation of a date
    /// - Returns: a formated Date String in the form of `MM/dd/yyyy`
    func getFormattedDate(of dateString: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = "MM/dd/yyyy"
        let date = dateformat.date(from: dateString) ?? Date()
        return dateformat.string(from: date)
    }
}
