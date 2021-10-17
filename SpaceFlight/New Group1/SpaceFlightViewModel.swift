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
    func fetchArticles() {
        let semaphore = DispatchSemaphore (value: 0)
        var request = URLRequest(url: URL(string: "\(url)\(slug)")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                semaphore.signal()
                return
            }
            print(String(data: data, encoding: . utf8)!)
            do {
                let articleModel = try? JSONDecoder().decode(Articles.self, from: data)
                
                self.articles.value = articleModel?.compactMap({ article in
                    SpaceFlightCellViewModel(id: article.id, title: article.title, url: article.url, imageURL: article.imageURL, summary: article.summary, date: article.publishedAt)
                    
                })
            }
            semaphore.signal()
        }

        task.resume()
        semaphore.wait()
    }
}




