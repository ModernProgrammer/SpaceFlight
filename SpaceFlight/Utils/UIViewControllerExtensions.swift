//
//  UIViewControllerExtensions.swift
//  SpaceFlight
//
//  Created by Diego Bustamante on 10/14/21.
//

import UIKit

extension UIViewController {
    /// Sets up a custom `UINavigationBar`
    /// - Parameters:
    ///   - prefersLargeTitles: The boolean if the large title is enabled for the navigationbar
    ///   - navigationTitle: The tint color for the navigation bar
    func setupNavBar(largeTitles prefersLargeTitles: Bool, title navigationTitle : String) {
        navigationController?.navigationBar.prefersLargeTitles = prefersLargeTitles
        navigationItem.title = navigationTitle
    }
}
