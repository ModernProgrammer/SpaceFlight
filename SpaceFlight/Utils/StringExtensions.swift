//
//  StringExtensions.swift
//  SpaceFlight
//
//  Created by Diego Bustamante on 10/17/21.
//

import Foundation

extension String {
    /// Gets a string date and formats it
    /// - Returns: a formated Date String in the form of `MM/dd/yyyy hh:mm:ss`
    func getFormattedDate() -> String {
        /// sets the date format
        let dateformat = DateFormatter()
        dateformat.dateFormat = "MM/dd/yyyy hh:mm:ss"
        let formatterISO8601 = ISO8601DateFormatter()
        formatterISO8601.formatOptions.insert(.withFractionalSeconds)
        /// formats the UTC Date to a regular date
        guard let formatterISO8601ToDate = formatterISO8601.date(from: self) else { return ""}
        return dateformat.string(from: formatterISO8601ToDate)
    }
}
