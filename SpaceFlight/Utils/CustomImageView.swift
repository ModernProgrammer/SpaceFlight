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
    /// - Parameters:
    ///   - urlString: The `URL`string of the image
    ///   - mode: Aspect ratio that is set to scaleAspectFit by default
    func downloadImage(from urlString: String, completion: ( (Result<Bool, ImageDownloadError>) -> Void)?) {
        setupSpinner()
        image = nil
        guard let url = URL(string: urlString) else { return }
        imageUrlString = urlString
        /// Checks to see if image was cache
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) as? UIImage {
            imageLoadingSpinner.removeFromSuperview()
            self.image = imageFromCache
            guard let completion = completion else { return }
            completion(.success(true))
            return
        }
        
        /// dataTask is called if the image has not been cached
        URLSession.shared.dataTask(with: url) { data, response, error in
            /// an error is returned if the data is unable to be retrieved from the server
            if error != nil {
                guard let completion = completion else { return }
                completion(.failure(.unableToComplete))
                return
            }
            
            /// an error is returned if a bad response is retrieved
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                guard let completion = completion else { return }
                completion(.failure(.invalidResponse))
                return
            }

            /// an error is returned if the data retrieved is invalid
            guard let data = data else {
                guard let completion = completion else { return }
                completion(.failure(.invalidData))
                return
            }
            
            DispatchQueue.main.async() { [weak self] in
                let image = UIImage(data: data)
                guard let imageToCache = image else { return }
                if self?.imageUrlString == urlString {
                    self?.image = imageToCache
                }
                guard let self = self else { return }
                /// caches image based on urlString
                imageCache.setObject(imageToCache, forKey: urlString as NSString)
                self.imageLoadingSpinner.removeFromSuperview()
                guard let completion = completion else { return }
                completion(.success(true))
            }
        }
        .resume()
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
}
