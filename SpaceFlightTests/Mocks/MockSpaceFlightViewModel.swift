//
//  MockSpaceFlightViewModel.swift
//  SpaceFlightTests
//
//  Created by Diego Bustamante on 10/27/21.
//

import Foundation
@testable import SpaceFlight

class MockSpaceFlightViewModel {
    var shouldReturnError = false
    var fetchArticlesWasCalled = false
    var mapArticleDataToModelWasCalled = false
   
    enum MockServiceError: Error {
        case fetchArticles
        case mapArticles
    }
    
    func reset() {
        shouldReturnError = false
        fetchArticlesWasCalled = false
        mapArticleDataToModelWasCalled = false
    }
    
    init(_ shouldReturnError: Bool) {
        self.shouldReturnError = shouldReturnError
    }
}

extension MockSpaceFlightViewModel: ArticlesApiClientProtocol {
    func fetchArticles(completion: @escaping (Result<Bool, APIError>) -> Void) {
        fetchArticlesWasCalled = true
        if shouldReturnError {
            completion(.failure(.unableToComplete))
        } else {
            completion(.success(true))
        }
    }
    
    func mapArticleDataToModel(from data: Data, completion: @escaping (Result<Bool, MapError>) -> Void) {
        mapArticleDataToModelWasCalled = true
        if shouldReturnError {
            completion(.failure(.invalidData))
        } else {
            completion(.success(true))
        }
    }
}
