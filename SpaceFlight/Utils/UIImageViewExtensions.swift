//
//  UIImageViewExtensions.swift
//  SpaceFlight
//
//  Created by Diego Bustamante on 10/15/21.
//

import UIKit

extension UIImageView {
    /// Sets the image from a given `URL` link
    ///
    /// - Parameters:
    ///     - url: The `URL` of the image
    ///     - contentMode: Aspect ratio that is set to scaleAspectFit by default
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    
    /// Sets the image from a given `link`
    ///
    /// - Parameters:
    ///     - link: The `link` of the image
    ///     - contentMode: Aspect ratio that is set to scaleAspectFit by default
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
