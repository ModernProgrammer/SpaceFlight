//
//  SpaceFlightDetailViewController.swift
//  SpaceFlight
//
//  Created by Diego Bustamante on 10/16/21.
//

import UIKit

class SpaceFlightDetailViewController : UIViewController {
    let topContainer    = UIView()
    let bottomContainer = UIView()
    let headTitle       = UILabel()
    let subTitle        = UILabel()
    let summary : UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textColor = .semanticTextColor()
        textView.isEditable = false
        return textView
    }()
    var urlLink         = ""
    let gradientView    = UIView()
    var gradient        : CAGradientLayer?
    
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let urlButton : UIButton = {
        let button = UIButton(type: .system)
        button.configuration = .tinted()
        button.configuration?.title = "Story"
        button.configuration?.baseForegroundColor = .systemRed
        button.configuration?.baseBackgroundColor = .systemRed
        button.configuration?.image = UIImage(systemName: "book.fill")
        button.configuration?.imagePadding = 6
        button.addTarget(self, action: #selector(storyLink), for: .touchUpInside)
        return button
    }()
    
    var article: SpaceFlightCellViewModel? {
        didSet {
            guard let headTitle = article?.title else { return }
            guard let subTitle = article?.date else { return }
            guard let summary = article?.summary else { return }
            guard let url = article?.url else { return }
            guard let imageURL = article?.imageURL else { return }
            imageView.downloaded(from: imageURL, contentMode: .scaleAspectFill)
            let headAttributedText = NSMutableAttributedString(string: headTitle, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 28, weight: .bold), NSAttributedString.Key.foregroundColor : UIColor.white])
            self.headTitle.numberOfLines = 0
            self.headTitle.attributedText = headAttributedText
            
            let stringDate  = Date().getFormattedDate(dateString: subTitle)
            let subAttributedText = NSMutableAttributedString(string: "Published on \(stringDate)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .thin), NSAttributedString.Key.foregroundColor : UIColor.white])
            self.subTitle.numberOfLines = 0
            self.subTitle.attributedText = subAttributedText
            
            let summaryAttributedText = NSMutableAttributedString(string: summary, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .regular), NSAttributedString.Key.foregroundColor : UIColor.white])
            self.summary.attributedText = summaryAttributedText
            self.urlLink = url
        }
    }
    
    /// creates a gradient view for the navigationbar
    func setupGradient() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupContainerStackView()
        setuptopContainer()
        setupBottomContainer()
    }

    
    @objc fileprivate func storyLink() {
        if let url = URL(string: urlLink) {
            UIApplication.shared.open(url)
        }
    }
    
    fileprivate func setupContainerStackView() {
        let stackView = UIStackView(arrangedSubviews: [topContainer, bottomContainer])
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 0
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        topContainer.translatesAutoresizingMaskIntoConstraints = false
        topContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 2/3).isActive = true
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    fileprivate func setuptopContainer() {
        topContainer.addSubview(imageView)
        let navBarHeight : CGFloat = 180
        let height : CGFloat = navBarHeight
        let color = UIColor.black.withAlphaComponent(0.8).cgColor
        let clear = UIColor.black.withAlphaComponent(0.0).cgColor
        gradient = view.setupGradient(height: height, topColor: color,bottomColor: clear)
        topContainer.addSubview(gradientView)
        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: view.topAnchor),
            gradientView.leftAnchor.constraint(equalTo: view.leftAnchor),
        ])
        gradientView.layer.insertSublayer(gradient!, at: 0)
        topContainer.addSubview(headTitle)
        topContainer.addSubview(subTitle)
        headTitle.translatesAutoresizingMaskIntoConstraints = false
        subTitle.translatesAutoresizingMaskIntoConstraints  = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topContainer.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: topContainer.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor),
            
            headTitle.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: 20),
            headTitle.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor, constant: 20),
            headTitle.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor, constant: -20),
            
            subTitle.topAnchor.constraint(equalTo: headTitle.bottomAnchor, constant: 10),
            subTitle.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor, constant: 20),
            subTitle.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor, constant: -20),
        ])
    }
    
    fileprivate func setupBottomContainer() {
        let blurEffectView = view.setupBlur(bounds: bottomContainer.bounds)
        bottomContainer.addSubview(blurEffectView)
        bottomContainer.addSubview(urlButton)
        bottomContainer.addSubview(summary)
    
        urlButton.translatesAutoresizingMaskIntoConstraints = false
        summary.translatesAutoresizingMaskIntoConstraints   = false

        NSLayoutConstraint.activate([
            urlButton.bottomAnchor.constraint(equalTo: bottomContainer.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            urlButton.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor, constant: 20),
            urlButton.widthAnchor.constraint(equalToConstant: view.frame.width/3),
            urlButton.heightAnchor.constraint(equalToConstant: 44),
            
            summary.topAnchor.constraint(equalTo: bottomContainer.topAnchor, constant: 20),
            summary.bottomAnchor.constraint(equalTo: urlButton.topAnchor, constant: -20),
            summary.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor, constant: 20),
            summary.trailingAnchor.constraint(equalTo: bottomContainer.trailingAnchor, constant: -20),
        ])
    }
}
