//
//  SpaceFlightModel.swift
//  SpaceFlight
//
//  Created by Diego Bustamante on 10/15/21.
//

import Foundation

// MARK: - Article
struct Article: Codable {
    let id: Int
    let title: String
    let url: String
    let imageURL: String
    let newsSite, summary, publishedAt, updatedAt: String
    let featured: Bool
    let launches: [Launch]
    let events: [JSONAny]

    enum CodingKeys: String, CodingKey {
        case id, title, url
        case imageURL = "imageUrl"
        case newsSite, summary, publishedAt, updatedAt, featured, launches, events
    }
}

// MARK: - Launch
struct Launch: Codable {
    let id, provider: String
}

typealias Articles = [Article]
