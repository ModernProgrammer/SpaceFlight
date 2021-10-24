//
//  SpaceFlightCell.swift
//  SpaceFlight
//
//  Created by Diego Bustamante on 10/15/21.
//

import UIKit

class SpaceFlightCell : UICollectionViewCell {
    let imageView : CustomImageView = {
        let imageView = CustomImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30
        imageView.backgroundColor = .themeBlack
        return imageView
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Test"
        return label
    }()
    
    let blurView : UIView = {
        let blurView = UIView()
        blurView.layer.cornerRadius = 30
        blurView.clipsToBounds = true
        return blurView
    }()
    
    var article: SpaceFlightCellViewModel? {
        didSet {
            guard let imageURL = article?.imageURL else { return }
            guard let title = article?.title else { return }
            guard let subTitle = article?.date else { return }
            let stringDate  = Date().getFormattedDate(dateString: subTitle)
            setupTitle(title: title, subTitle: stringDate)
            imageView.downloadImage(from: imageURL, contentMode: .scaleAspectFill)
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
extension SpaceFlightCell {
    private func setupUI() {
        addSubview(imageView)
        addSubview(blurView)
        addSubview(titleLabel)
        imageView.translatesAutoresizingMaskIntoConstraints  = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        blurView.translatesAutoresizingMaskIntoConstraints   = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            blurView.heightAnchor.constraint(equalToConstant: 128),
            
            titleLabel.topAnchor.constraint(equalTo: blurView.topAnchor, constant: 20),
            titleLabel.bottomAnchor.constraint(equalTo: blurView.bottomAnchor, constant: -20),
            titleLabel.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: blurView.trailingAnchor, constant: -20)
        ])
        let blurEffectView = setupBlur(from: blurView.bounds)
        blurEffectView.layer.cornerRadius = 30
        blurView.addSubview(blurEffectView)
    }
    
    private func setupTitle(title: String, subTitle: String) {
        let attributedTitle = NSMutableAttributedString(string: "\(title)\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .bold), NSAttributedString.Key.foregroundColor : UIColor.white])
        attributedTitle.append(NSMutableAttributedString(string: "Published on \(subTitle)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .thin), NSAttributedString.Key.foregroundColor : UIColor.white]))
        titleLabel.attributedText = attributedTitle
    }
}
