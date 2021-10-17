//
//  UIViewControllerExtensions.swift
//  SpaceFlight
//
//  Created by Diego Bustamante on 10/14/21.
//

import UIKit

extension UIViewController {
    /// Returns a custom navigationBar
    /// from the given components.
    ///
    /// - Parameters:
    ///     - prefersLargeTitles: The boolean if the large title is enabled for the navigationbar
    ///     - navTitle: The tint color for the navigation bar
    func setupNavBar(prefersLargeTitles : Bool, navTitle : String) {
        navigationController?.navigationBar.prefersLargeTitles = prefersLargeTitles
        navigationItem.title = navTitle
    }
}
