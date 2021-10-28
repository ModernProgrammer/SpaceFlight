//
//  SpaceFlightViewModel.swift
//  SpaceFlight
//
//  Created by Diego Bustamante on 10/14/21.
//

import UIKit
import Foundation

class SpaceFlightViewModel {
    var articles: Observable<[SpaceFlightCellViewModel]> = Observable([])
    
    /// Documentation: `https://api.spaceflightnewsapi.net/v3/documentation`
    let apiUrl: String = "https://api.spaceflightnewsapi.net/v3"
    let apiSlug: String = "/articles"
}

// MARK: - API Functions
extension SpaceFlightViewModel: ArticlesApiClientProtocol {
    /// Hits the API Endpoint `https://api.spaceflightnewsapi.net/v3/articles` and stores the return data into `articles`
    /// - Parameter completion: Returns a boolean determing if the call was successful
    ///                         and return an APIError type with the description if it fails
    func fetchArticles(completion: @escaping(Result<Bool, APIError>) -> Void) {
        let semaphore = DispatchSemaphore (value: 0)
        guard let url = URL(string: "\(apiUrl)\(apiSlug)") else { return }
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            /// an error is returned if the data is unable to be retrieved from the server
            if error != nil {
                semaphore.signal()
                completion(.failure(.unableToComplete))
                return
            }
            
            /// an error is returned if a bad response is retrieved
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                semaphore.signal()
                completion(.failure(.invalidResponse))
                return
            }

            /// an error is returned if the data retrieved is invalid
            guard let data = data else {
                semaphore.signal()
                completion(.failure(.invalidData))
                return
            }
            
            self.mapArticleDataToModel(from: data) { result in
                switch result {
                case .success(_):
                    completion(.success(true))
                    return
                case .failure(_):
                    completion(.failure(.invalidData))
                    return
                }
            }
            
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    
    /// Maps the returned data from the API to the articles value
    /// - Parameters:
    ///   - data: The retrieved JSON data from the API
    ///   - completion: Returns either a successful boolean or a failure of mapping error
    func mapArticleDataToModel(from data: Data, completion: @escaping(Result<Bool, MapError>) -> Void) {
        do {
            let articleModel = try JSONDecoder().decode(Articles.self, from: data)
            self.articles.value = articleModel.compactMap({ article in
                SpaceFlightCellViewModel(
                    id: article.id,
                    title: article.title,
                    url: article.url,
                    imageURL: article.imageURL,
                    summary: article.summary,
                    date: article.publishedAt
                )
            })
            ///  returns successful if the articleModel gets properly mapped to the articles in the viewModel
            completion(.success(true))
        } catch {
            completion(.failure(.invalidData))
        }
    }
}




