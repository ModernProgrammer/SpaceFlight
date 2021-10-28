//
//  MockCustimImageView.swift
//  SpaceFlightTests
//
//  Created by Diego Bustamante on 10/27/21.
//

import Foundation
@testable import SpaceFlight

class MockCustomImageView {
    var shouldReturnError = false
    var downloadImageWasCalled = false
    
    enum MockServiceError: Error {
        case fetchArticles
    }
    
    func reset() {
        shouldReturnError = false
        downloadImageWasCalled = false
    }
    
    init(_ shouldReturnError: Bool) {
        self.shouldReturnError = shouldReturnError
    }
}

extension MockCustomImageView: UIImageUrlLinkDownLoadProtocol {
    func downloadImage(from urlString: String, completion: ((Result<Bool, ImageDownloadError>) -> Void)?) {
        downloadImageWasCalled = true
        guard let completion = completion else {
            return
        }
        if shouldReturnError {
            completion(.failure(.unableToComplete))
        } else {
            completion(.success(true))
        }
    }
}
