//
//  SpaceFlightModel.swift
//  SpaceFlight
//
//  Created by Diego Bustamante on 10/15/21.
//

import Foundation

// MARK: - Article
struct Article: Codable {
    let id          : Int
    let title       : String
    let url         : String
    let imageURL    : String
    let summary     : String
    let publishedAt : String
 
    enum CodingKeys: String, CodingKey {
        case id, title, url
        case imageURL = "imageUrl"
        case summary, publishedAt
    }
}

typealias Articles = [Article]


