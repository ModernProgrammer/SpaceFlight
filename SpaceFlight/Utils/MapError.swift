//
//  MapError.swift
//  SpaceFlight
//
//  Created by Diego Bustamante on 10/27/21.
//

import Foundation

/// A enum that handles different error types from a connection failure
enum MapError: String, Error {
    case invalidData = "The data revieved from the server was invalid."
}
