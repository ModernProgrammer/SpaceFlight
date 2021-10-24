//
//  SpaceFlightViewController.swift
//  SpaceFlight
//
//  Created by Diego Bustamante on 10/14/21.
//

import UIKit

// Homes
class SpaceFlightViewController: UICollectionViewController {
    let cellId                 = "cellId"
    let navigationTitle        = "Space Flight"
    var apiLoadingSpinner      = UIActivityIndicatorView(style: .large)
    let spaceFlightViewModel   = SpaceFlightViewModel()
    let errorMessage           = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor()
        setupNavBar(largeTitles: true, title: navigationTitle)
        setupAPILoadingSpinner()
        bindArticleModeltoCollectionView()
        fetchArticlesAPI()
        setupCollectionViewProperties()
    }
}

// MARK: -SpaceFlightViewModel Functions
extension SpaceFlightViewController {
    /// Binds the Article Observable to the collection view
    fileprivate func bindArticleModeltoCollectionView() {
        self.spaceFlightViewModel.articles.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    /// Makes an API request to the SpaceFlight API
    fileprivate func fetchArticlesAPI() {
        // run article binding and fetchArticles in the background thread
        DispatchQueue.global(qos: .userInitiated).async {
            self.spaceFlightViewModel.fetchArticles { result in
                DispatchQueue.main.async {
                    self.removeFromView(self.apiLoadingSpinner)
                }
                switch result {
                case .success(_):
                    return
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.showErrorMessage(from: error.rawValue)
                    }
                }
            }
        }
    }
}

// MARK: -UI Functions
extension SpaceFlightViewController {
    /// Sets up the apiLoadingSpinner to the view
    func setupAPILoadingSpinner() {
        view.addSubview(apiLoadingSpinner)
        apiLoadingSpinner.startAnimating()
        apiLoadingSpinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            apiLoadingSpinner.topAnchor.constraint(equalTo: view.topAnchor),
            apiLoadingSpinner.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            apiLoadingSpinner.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            apiLoadingSpinner.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    /// Removes a subview from the superview
    /// - Parameter subView: the subview being removed
    func removeFromView(_ subView: UIView) {
        subView.removeFromSuperview()
    }
    
    
    /// Displays an Error message for the user
    /// - Parameter error: error message of the
    func showErrorMessage(from error : String) {
        view.addSubview(errorMessage)
        errorMessage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorMessage.topAnchor.constraint(equalTo: view.topAnchor),
            errorMessage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            errorMessage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            errorMessage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        let attributedText = NSMutableAttributedString(string: "Error\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 28, weight: .regular), NSAttributedString.Key.foregroundColor : UIColor.systemRed])
        attributedText.append(NSMutableAttributedString(string: error, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .thin), NSAttributedString.Key.foregroundColor : UIColor.systemRed]))
        
        errorMessage.attributedText = attributedText
        errorMessage.numberOfLines = 0
        errorMessage.textAlignment = .center
    }
    
    /// Configures the collectionView properties
    fileprivate func setupCollectionViewProperties() {
        collectionView.isPagingEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.register(SpaceFlightArticleCell.self, forCellWithReuseIdentifier: cellId)
    }
}

// MARK: -UICollectionView Functions
extension SpaceFlightViewController : UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return spaceFlightViewModel.articles.value?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SpaceFlightArticleCell
        cell.article = spaceFlightViewModel.articles.value?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let height = view.frame.height/2
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = SpaceFlightDetailViewController()
        viewController.article = spaceFlightViewModel.articles.value?[indexPath.row]
        present(viewController, animated: true, completion: nil)
    }
}

