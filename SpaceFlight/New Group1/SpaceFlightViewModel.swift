//
//  SpaceFlightViewModel.swift
//  SpaceFlight
//
//  Created by Diego Bustamante on 10/14/21.
//

import UIKit
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

class SpaceFlightViewModel  {
    var articles: Observable<[SpaceFlightCellViewModel]> = Observable([])
    
    /// Documentation: `https://api.spaceflightnewsapi.net/v3/documentation`
    let url  : String = "https://api.spaceflightnewsapi.net/v3"
    let slug : String = "/articles"
    
    /// Hits the API Endpoint `https://api.spaceflightnewsapi.net/v3/articles` and stores the return data into `articles`
    /// - Parameter completion: Returns a boolean determing if the call was successful and return an APIError type with the description if it fails
    func fetchArticles(completion: @escaping (Result<Bool, APIError>)->Void) {
        let semaphore = DispatchSemaphore (value: 0)
        var request = URLRequest(url: URL(string: "\(url)\(slug)")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }

            guard let data = data else {
                semaphore.signal()
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let articleModel = try JSONDecoder().decode(Articles.self, from: data)
                self.articles.value = articleModel.compactMap({ article in
                    SpaceFlightCellViewModel(id: article.id, title: article.title, url: article.url, imageURL: article.imageURL, summary: article.summary, date: article.publishedAt)
                })
                completion(.success(true))
            } catch {
                completion(.failure(.invalidData))
            }
            semaphore.signal()
        }

        task.resume()
        semaphore.wait()
    }
}




