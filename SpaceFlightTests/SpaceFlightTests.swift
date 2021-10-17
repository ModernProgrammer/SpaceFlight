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
    var viewModel : SpaceFlightViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = SpaceFlightViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func test_fetch_articles() {
        viewModel.fetchArticles()
        let articles = viewModel.articles
        XCTAssertNotNil(articles)
    }
    
    func test_get_formatted_date() {
        let dateString = "2021-10-16T00:09:09.000Z"
        let formattedDate = Date().getFormattedDate(dateString: dateString)
        XCTAssertEqual(formattedDate, "10/17/2021")
    }
    
    func test_rgb_format() {
        let color = UIColor.rgb(red: 24, green: 24, blue: 24, alpha: 1)
        let color2 = UIColor(red: 24/255, green: 24/255, blue: 24/255, alpha: 1)
        XCTAssertEqual(color, color2)
    }
    
    func test_set_up_blur() {
        let view = UIView()
        let blur = view.setupBlur(bounds: view.bounds)
        XCTAssertNotNil(blur)
    }
    
    func test_set_up_gradient() {
        let view = UIView()
        let gradient = view.setupGradient(height: 0, topColor: UIColor.blue.cgColor, bottomColor: UIColor.blue.cgColor)
        XCTAssertNotNil(gradient)
    }
}
