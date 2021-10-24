//
//  SpaceFlightViewController.swift
//  SpaceFlight
//
//  Created by Diego Bustamante on 10/14/21.
//

import UIKit

// Controller
class SpaceFlightViewController: UIViewController {
    private var prevScrollDirection: CGFloat = 0
    let cellId                 = "cellId"
    let navigationTitle        = "Space Flight"
    var apiLoadingSpinner      = UIActivityIndicatorView(style: .large)
    let spaceFlightViewModel   = SpaceFlightViewModel()
    let errorMessage             = UILabel()

        
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.register(SpaceFlightCell.self, forCellWithReuseIdentifier: cellId)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSpinner()
        setupUIComponents()
        setupCollectionView()
        fetchArticlesAPI()
    }
    
    func setupSpinner() {
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
    
    /// Removes the `View` on the UIImageView
    func removeFromView(_ view: UIView) {
        view.removeFromSuperview()
    }
    
    fileprivate func fetchArticlesAPI() {
        // run article binding and fetchArticles in the background thread
        DispatchQueue.global(qos: .userInitiated).async {
            self.spaceFlightViewModel.articles.bind { [weak self] _ in
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
            
            self.spaceFlightViewModel.fetchArticles { result in
                DispatchQueue.main.async {
                    self.removeFromView(self.apiLoadingSpinner)
                }
                switch result {
                    
                case .success(_):
                    // Success
                    print()
                case .failure(let error):
                    print("Failure")
                    DispatchQueue.main.async {
                        self.removeFromView(self.apiLoadingSpinner)
                        self.showErrorMessage(from: error.rawValue)
                    }
                }
            }
        }
    }
    
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
// MARK: -UI Functions
extension SpaceFlightViewController {
    /// setups up basic UI
    func setupUIComponents() {
        setupNavBar(largeTitles: true, title: navigationTitle)
        view.backgroundColor = .backgroundColor()
    }
    
    /// Adds the collectionView to the view and anchors it using autolayout constraints
    func setupCollectionView() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
}

// MARK: -UICollectionView Functions
extension SpaceFlightViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return spaceFlightViewModel.articles.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SpaceFlightCell
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = SpaceFlightDetailViewController()
        viewController.article = spaceFlightViewModel.articles.value?[indexPath.row]
        present(viewController, animated: true, completion: nil)
    }
    
    func selectedCellView() -> SpaceFlightCell? {
        guard let indexPath = collectionView.indexPathsForSelectedItems else { return nil }
        let cell = collectionView.cellForItem(at: indexPath[0]) as! SpaceFlightCell
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewY = scrollView.contentOffset.y
        let scrollSizeHeight = scrollView.contentSize.height
        let scrollFrameHeight = scrollView.frame.height
        let scrollHeight = scrollSizeHeight - scrollFrameHeight
        var isHidden = false

        if prevScrollDirection > scrollViewY && prevScrollDirection < scrollHeight {
            isHidden = false
        } else if prevScrollDirection < scrollViewY && scrollViewY > 0 {
            isHidden = true
        }
        let userInfo : [String : Bool] = [ "isHidden" : isHidden ]
        NotificationCenter.default.post(name: Notification.Name(rawValue: "tabbar"), object: nil, userInfo: userInfo)
        prevScrollDirection = scrollView.contentOffset.y
    }
    
}

