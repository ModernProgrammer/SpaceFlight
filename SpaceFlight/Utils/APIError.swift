//
//  APIError.swift
//  SpaceFlight
//
//  Created by Diego Bustamante on 10/24/21.
//

import Foundation

/// A enum that handles different error types from a connection failure
enum APIError: String, Error {
    case invalidData = "The data revieved from the server was invalid."
    case invalidResponse = "Invalid response from the server."
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
}
