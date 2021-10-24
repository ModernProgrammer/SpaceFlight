//
//  APIError.swift
//  SpaceFlight
//
//  Created by Diego Bustamante on 10/24/21.
//

import Foundation

enum APIError: String, Error {
    case invalidData      = "The data revieved from the server was invalid. Please Try Again."
    case invalidResponse  = "Invalid response from the server. Please try again"
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
}
