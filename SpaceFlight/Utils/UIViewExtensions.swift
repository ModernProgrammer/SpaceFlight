//
//  UIViewExtensions.swift
//  SpaceFlight
//
//  Created by Diego Bustamante on 10/17/21.
//

import UIKit

extension UIView {
    /// Returns a gradient layer from two colors
    /// from the given components.
    ///
    /// - Parameters:
    ///     - bounds: The bounds of the gradient
    func setupBlur(from bounds: CGRect) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame =  bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }
    
    /// Returns a gradient layer from two colors
    /// from the given components.
    ///
    /// - Parameters:
    ///     - height: The height of the gradient
    ///     - topColor: The top color of the gradient
    ///     - bottomColor: The bottom color of the gradient
    func setupGradient(height: CGFloat, from topColor: CGColor, to bottomColor: CGColor) ->  CAGradientLayer {
         let gradient: CAGradientLayer = CAGradientLayer()
         gradient.colors = [topColor,bottomColor]
         gradient.locations = [0.0 , 1.0]
         gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
         gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
         gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: height)
         return gradient
    }    
}
