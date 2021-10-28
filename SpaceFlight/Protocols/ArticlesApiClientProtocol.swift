//
//  ArticlesApiClientProtocol.swift
//  SpaceFlight
//
//  Created by Diego Bustamante on 10/27/21.
//

import Foundation

protocol ArticlesApiClientProtocol {
    func fetchArticles(completion: @escaping(Result<Bool, APIError>) -> Void)
    func mapArticleDataToModel(from data: Data, completion: @escaping(Result<Bool, MapError>) -> Void)
}
