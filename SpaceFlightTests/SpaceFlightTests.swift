//
//  SpaceFlightTests.swift
//  SpaceFlightTests
//
//  Created by Diego Bustamante on 10/14/21.
//

import XCTest
import UIKit
@testable import SpaceFlight

class SpaceFlightTests: XCTestCase {
    var viewModel = MockSpaceFlightViewModel(true)
    var mockCustomImageView = MockCustomImageView(true)

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func test_get_formatted_date() {
        let dateString = "2021-10-16T00:09:09.000Z"
        let formattedDate = dateString.getFormattedDate()
        XCTAssertEqual(formattedDate, "10/15/2021 08:09:09")
    }
    
    func test_rgb_format() {
        let color = UIColor.rgb(red: 24, green: 24, blue: 24, alpha: 1)
        let color2 = UIColor(red: 24/255, green: 24/255, blue: 24/255, alpha: 1)
        XCTAssertEqual(color, color2)
    }
    
    func test_set_up_blur() {
        let view = UIView()
        let blur = view.setupBlur(from: view.bounds)
        XCTAssertNotNil(blur)
    }
    
    func test_set_up_gradient() {
        let view = UIView()
        let gradient = view.setupGradient(height: 0, startColor: UIColor.blue.cgColor, endColor: UIColor.blue.cgColor)
        XCTAssertNotNil(gradient)
    }
    
    func test_fetch_articles_data_reponse() {
        viewModel.fetchArticles { result in
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(error, APIError.unableToComplete)
                return
            case .success(let success):
                XCTAssertTrue(success)
                return
            }
        }
    }
    
    func test_bind_article_data_to_model() {
        let jsonResponse = "[{\"id\": 11349,\"title\": \"OneWeb and Saudi Arabia create $200 million connectivity joint venture\",\"url\":\"https://spacenews.com/oneweb-and-saudi-arabia-create-200-million-connectivity-joint-venture/\",\"imageUrl\":\"https://spacenews.com/wp-content/uploads/2021/09/OW-Constellation-1.png\",\"newsSite\": \"SpaceNews\",\"summary\": \"Satellite broadband startup OneWeb and a company backed by Saudi Arabia’s sovereign wealth fund have signed a $200 million joint venture, with exclusive rights to distribute the network’s capacity in targeted Middle East regions.\",\"publishedAt\": \"2021-10-27T21:03:14.000Z\",\"updatedAt\": \"2021-10-27T21:03:14.957Z\",\"featured\": false,\"launches\": [],\"events\": []}]"
        let data = jsonResponse.data(using: .utf8)!
        viewModel.mapArticleDataToModel(from: data) { result in
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(error, MapError.invalidData)
                return
            case .success(let success):
                XCTAssertTrue(success)
                return
            }
        }
    }
    
    func test_download_image_from_url_response() {
        let urlString = "https://spacenews.com/wp-content/uploads/2021/09/OW-Constellation-1.png"
        mockCustomImageView.downloadImage(from: urlString, completion: { result in
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(error, ImageDownloadError.unableToComplete)
                return
            case .success(let success):
                XCTAssertTrue(success)
                return
            }
        })
    }
}
