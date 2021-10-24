//
//  SpaceFlightDetailViewController.swift
//  SpaceFlight
//
//  Created by Diego Bustamante on 10/16/21.
//

import UIKit

class SpaceFlightDetailViewController : UIViewController {
    let articleImageContainer    = UIView()
    let articleSummaryContainer  = UIView()
    let articleTitleLabel        = UILabel()
    let articleDateLabel         = UILabel()
    var articleURLLink           = ""
    let articleTitleGradientView = UIView()
    var gradient                 : CAGradientLayer?
    
    let articleSummary : UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textColor = .semanticTextColor()
        textView.isEditable = false
        return textView
    }()
    
    let articleImageView : CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .themeBlack
        return imageView
    }()
    
    let articleURLButton : UIButton = {
        let button = UIButton(type: .system)
        button.configuration = .tinted()
        button.configuration?.title = "Story"
        button.configuration?.baseForegroundColor = .systemRed
        button.configuration?.baseBackgroundColor = .systemRed
        button.configuration?.image = UIImage(systemName: "book.fill")
        button.configuration?.imagePadding = 6
        button.addTarget(self, action: #selector(storyURLLink), for: .touchUpInside)
        return button
    }()
    
    var article: SpaceFlightCellViewModel? {
        didSet {
            guard let headTitle = article?.title else { return }
            guard let subTitle = article?.date else { return }
            guard let summary = article?.summary else { return }
            guard let url = article?.url else { return }
            guard let imageURL = article?.imageURL else { return }
            setupTitles(articleTitle: headTitle, articleDate: subTitle, articleSummary: summary, articleURL: url)
            articleImageView.downloadImage(from: imageURL, contentMode: .scaleAspectFill)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupContainerStackView()
        setupImageContainer()
        setupSummaryContainer()
    }
}
// MARK: -Action
extension SpaceFlightDetailViewController {
    ///  Redirects the user to the link of the story url
    @objc fileprivate func storyURLLink() {
        if let url = URL(string: articleURLLink) {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: -UI Functions
extension SpaceFlightDetailViewController {
    /// Adds an attributed title from the article model to  `articleTitle`, `articleDate`, `articleSummary` and `articleURL`
    /// - Parameters:
    ///   - articleTitle: The title of the article
    ///   - articleDate: The published date of the article
    ///   - articleSummary: The summary of the article
    ///   - articleURL: The URL link to the full article
    fileprivate func setupTitles(articleTitle: String, articleDate: String, articleSummary: String, articleURL: String) {
        let headAttributedText = NSMutableAttributedString(string: articleTitle, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 28, weight: .bold), NSAttributedString.Key.foregroundColor : UIColor.white])
        self.articleTitleLabel.numberOfLines = 0
        self.articleTitleLabel.attributedText = headAttributedText
        
        let stringDate  = Date().getFormattedDate(dateString: articleDate)
        let subAttributedText = NSMutableAttributedString(string: "Published on \(stringDate)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .thin), NSAttributedString.Key.foregroundColor : UIColor.white])
        self.articleDateLabel.numberOfLines = 0
        self.articleDateLabel.attributedText = subAttributedText
        
        let summaryAttributedText = NSMutableAttributedString(string: articleSummary, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .regular), NSAttributedString.Key.foregroundColor : UIColor.white])
        self.articleSummary.attributedText = summaryAttributedText
        self.articleURLLink = articleURL
    }
    
    /// adds the `articleImageContainer` and `articleSummaryContainer` to view
    fileprivate func setupContainerStackView() {
        let stackView = UIStackView(arrangedSubviews: [articleImageContainer, articleSummaryContainer])
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 0
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        articleImageContainer.translatesAutoresizingMaskIntoConstraints = false
        articleImageContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 2/3).isActive = true
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    /// adds the `articleImageContainer` and `articleSummaryContainer` to view
    fileprivate func setupImageContainer() {
        articleImageContainer.addSubview(articleImageView)
        let navBarHeight : CGFloat = 180
        let gradientHeight : CGFloat = navBarHeight
        let topGradientColor = UIColor.black.withAlphaComponent(0.8).cgColor
        let bottomGradientColor = UIColor.black.withAlphaComponent(0.0).cgColor
        gradient = view.setupGradient(height: gradientHeight, startColor: topGradientColor, endColor: bottomGradientColor)
        articleImageContainer.addSubview(articleTitleGradientView)
        NSLayoutConstraint.activate([
            articleTitleGradientView.topAnchor.constraint(equalTo: view.topAnchor),
            articleTitleGradientView.leftAnchor.constraint(equalTo: view.leftAnchor),
        ])
        articleTitleGradientView.layer.insertSublayer(gradient!, at: 0)
        articleImageContainer.addSubview(articleTitleLabel)
        articleImageContainer.addSubview(articleDateLabel)
        articleTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        articleDateLabel.translatesAutoresizingMaskIntoConstraints  = false
        articleImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            articleImageView.topAnchor.constraint(equalTo: articleImageContainer.topAnchor),
            articleImageView.bottomAnchor.constraint(equalTo: articleImageContainer.bottomAnchor),
            articleImageView.leadingAnchor.constraint(equalTo: articleImageContainer.leadingAnchor),
            articleImageView.trailingAnchor.constraint(equalTo: articleImageContainer.trailingAnchor),
            
            articleTitleLabel.topAnchor.constraint(equalTo: articleImageContainer.topAnchor, constant: 20),
            articleTitleLabel.leadingAnchor.constraint(equalTo: articleImageContainer.leadingAnchor, constant: 20),
            articleTitleLabel.trailingAnchor.constraint(equalTo: articleImageContainer.trailingAnchor, constant: -20),
            
            articleDateLabel.topAnchor.constraint(equalTo: articleTitleLabel.bottomAnchor, constant: 10),
            articleDateLabel.leadingAnchor.constraint(equalTo: articleImageContainer.leadingAnchor, constant: 20),
            articleDateLabel.trailingAnchor.constraint(equalTo: articleImageContainer.trailingAnchor, constant: -20),
        ])
    }
    
    /// adds the `articleURLButton` and `articleSummary` to the articleSummary container with a blur background
    fileprivate func setupSummaryContainer() {
        let blurEffectView = view.setupBlur(from: articleSummaryContainer.bounds)
        articleSummaryContainer.addSubview(blurEffectView)
        articleSummaryContainer.addSubview(articleURLButton)
        articleSummaryContainer.addSubview(articleSummary)
    
        articleURLButton.translatesAutoresizingMaskIntoConstraints = false
        articleSummary.translatesAutoresizingMaskIntoConstraints   = false

        NSLayoutConstraint.activate([
            articleURLButton.bottomAnchor.constraint(equalTo: articleSummaryContainer.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            articleURLButton.leadingAnchor.constraint(equalTo: articleSummaryContainer.leadingAnchor, constant: 20),
            articleURLButton.widthAnchor.constraint(equalToConstant: view.frame.width/3),
            articleURLButton.heightAnchor.constraint(equalToConstant: 44),
            
            articleSummary.topAnchor.constraint(equalTo: articleSummaryContainer.topAnchor, constant: 20),
            articleSummary.bottomAnchor.constraint(equalTo: articleURLButton.topAnchor, constant: -20),
            articleSummary.leadingAnchor.constraint(equalTo: articleSummaryContainer.leadingAnchor, constant: 20),
            articleSummary.trailingAnchor.constraint(equalTo: articleSummaryContainer.trailingAnchor, constant: -20),
        ])
    }
}
