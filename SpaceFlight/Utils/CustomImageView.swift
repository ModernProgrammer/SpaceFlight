//
//  CustomImageView.swift
//  SpaceFlight
//
//  Created by Diego Bustamante on 10/15/21.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView {
    var imageUrlString: String?
    var imageLoadingSpinner = UIActivityIndicatorView(style: .large)

    /// Gets the image from a given `URL` link
    ///
    /// - Parameters:
    ///     - urlString: The `URL`string  of the image
    ///     - contentMode: Aspect ratio that is set to scaleAspectFit by default
    func downloadImage(from urlString: String, contentMode mode: ContentMode = .scaleAspectFit) {
        setupSpinner()
        contentMode = mode
        image = nil
        let url = URL(string: urlString)
        imageUrlString = urlString
        // Checks to see if image was cache
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) as? UIImage {
            removeFromView(imageLoadingSpinner)
            self.image = imageFromCache
            return
        }
        
        // dataTask is called if the image has not been cached
        URLSession.shared.dataTask(with: url!) { data, _, error in
            guard
                let data = data, error == nil
                else { return }
            DispatchQueue.main.async() { [weak self] in
                let image = UIImage(data: data)
                guard let imageToCache = image else { return }
                if self?.imageUrlString == urlString {
                    self?.image = imageToCache
                }
                imageCache.setObject(imageToCache, forKey: urlString as NSString)
                self!.removeFromView(self!.imageLoadingSpinner)
            }
        }.resume()
    }
    
    /// Sets up the `UIActivityIndicatorView` on the UIImageView
    func setupSpinner() {
        addSubview(imageLoadingSpinner)
        imageLoadingSpinner.backgroundColor = .systemGray
        imageLoadingSpinner.startAnimating()
        imageLoadingSpinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageLoadingSpinner.topAnchor.constraint(equalTo: topAnchor),
            imageLoadingSpinner.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageLoadingSpinner.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageLoadingSpinner.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    /// Removes the `UIActivityIndicatorView` on the UIImageView
    func removeFromView(_ view: UIView) {
        view.removeFromSuperview()
    }
}

