//
//  UIColorExtensions.swift
//  SpaceFlight
//
//  Created by Diego Bustamante on 10/14/21.
//

import UIKit

import UIKit

extension UIColor {
    /// Returns an off black color
    static let themeBlack = UIColor.rgb(red: 30, green: 30, blue: 30, alpha: 1)
    
    /// Creates a `UIColor` RGB value by simplifing the RBG values
    /// - Parameters:
    ///   - red: The CGFloat value for red
    ///   - green: The CGFloat value for green
    ///   - blue: The CGFloat value for blue
    ///   - alpha: The CGFloat value for alpha intensity
    /// - Returns: a `UIColor`
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    
    /// Returns the semantic background color
    static func backgroundColor() -> UIColor {
        if #available(iOS 13, *) {
            return UIColor.init { (trait) -> UIColor in
                return trait.userInterfaceStyle == .dark ? UIColor.themeBlack : UIColor.white
            }
        }
        else { return UIColor.white }
    }
    
    /// Returns the semantic text color
    static func semanticTextColor() -> UIColor {
        if #available(iOS 13, *) {
            return UIColor.init { (trait) -> UIColor in
                return trait.userInterfaceStyle == .dark ? UIColor.white : UIColor.themeBlack
            }
        }
        else { return UIColor.themeBlack }
    }
}
