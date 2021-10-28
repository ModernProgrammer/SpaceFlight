//
//  UIViewExtensions.swift
//  SpaceFlight
//
//  Created by Diego Bustamante on 10/17/21.
//

import UIKit

extension UIView {
    /// Creates a blur view using `UIVisualEffectView`
    /// - Parameter bounds: The desired bounds size
    /// - Returns: `UIVisualEffectView` based on the bounds from the user
    func setupBlur(from bounds: CGRect) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }
    
    /// Creates a`CAGradientLayer` from two different CGColors
    /// - Parameters:
    ///   - height: The desired `height` of the gradient
    ///   - topColor: The top color of the gradient
    ///   - bottomColor: The bottom color of the gradient
    /// - Returns: `CAGradientLayer` from two different CGColors
    func setupGradient(height: CGFloat, startColor topColor: CGColor, endColor bottomColor: CGColor) -> CAGradientLayer {
         let gradient: CAGradientLayer = CAGradientLayer()
         gradient.colors = [topColor, bottomColor]
         gradient.locations = [0.0, 1.0]
         gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
         gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
         gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: height)
         return gradient
    }
    
    
    /// Creates an attributed Text string
    /// - Parameters:
    ///   - textString: The text string for the attributed text
    ///   - fontSize: The desired size of the font
    ///   - textWeight: The desired weight of the font
    ///   - textColor: The desired text color
    /// - Returns: `NSMutableAttributedString` with the custom properties
    func setupAttributedText(text textString: String, size fontSize: CGFloat, weight textWeight: UIFont.Weight, color textColor: UIColor) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: textString, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: textWeight),
            NSAttributedString.Key.foregroundColor: textColor
        ])
        return attributedString
    }
}
