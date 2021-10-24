//
//  SpaceFlightCell.swift
//  SpaceFlight
//
//  Created by Diego Bustamante on 10/15/21.
//

import UIKit

class SpaceFlightArticleCell : UICollectionViewCell {
    let articleImage : CustomImageView = {
        let imageView = CustomImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30
        imageView.backgroundColor = .themeBlack
        return imageView
    }()
    
    let articleTitleLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    let articleContainerBlur : UIView = {
        let blurView = UIView()
        blurView.layer.cornerRadius = 30
        blurView.clipsToBounds = true
        return blurView
    }()
    
    var article: SpaceFlightCellViewModel? {
        didSet {
            guard let articleImageURL = article?.imageURL else { return }
            guard let articleTitle = article?.title else { return }
            guard let articleDate = article?.date else { return }
            let stringDate  = Date().getFormattedDate(dateString: articleDate)
            setupTitle(articleTitle: articleTitle, articleDate: stringDate)
            articleImage.downloadImage(from: articleImageURL, contentMode: .scaleAspectFill)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: -UI Functions
extension SpaceFlightArticleCell {
    /// setups the `articleImage`, `articleContainerBlur`, `articleTitle` to the cell
    private func setupUI() {
        addSubview(articleImage)
        addSubview(articleContainerBlur)
        addSubview(articleTitleLabel)
        articleImage.translatesAutoresizingMaskIntoConstraints  = false
        articleTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        articleContainerBlur.translatesAutoresizingMaskIntoConstraints   = false
        NSLayoutConstraint.activate([
            articleImage.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            articleImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            articleImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            articleImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            articleContainerBlur.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40),
            articleContainerBlur.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            articleContainerBlur.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            articleContainerBlur.heightAnchor.constraint(equalToConstant: 128),
            
            articleTitleLabel.topAnchor.constraint(equalTo: articleContainerBlur.topAnchor, constant: 20),
            articleTitleLabel.bottomAnchor.constraint(equalTo: articleContainerBlur.bottomAnchor, constant: -20),
            articleTitleLabel.leadingAnchor.constraint(equalTo: articleContainerBlur.leadingAnchor, constant: 20),
            articleTitleLabel.trailingAnchor.constraint(equalTo: articleContainerBlur.trailingAnchor, constant: -20)
        ])
        let blurEffectView = setupBlur(from: articleContainerBlur.bounds)
        blurEffectView.layer.cornerRadius = 30
        articleContainerBlur.addSubview(blurEffectView)
    }
    
    
    /// Creates a `NSMutableAttributedString` label for the cell
    /// - Parameters:
    ///   - articleTitle: The title of the article
    ///   - articleDate: The published date of the article
    private func setupTitle(articleTitle: String, articleDate: String) {
        let attributedTitle = NSMutableAttributedString(string: "\(articleTitle)\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .bold), NSAttributedString.Key.foregroundColor : UIColor.white])
        attributedTitle.append(NSMutableAttributedString(string: "Published on \(articleDate)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .thin), NSAttributedString.Key.foregroundColor : UIColor.white]))
        articleTitleLabel.attributedText = attributedTitle
    }
}
