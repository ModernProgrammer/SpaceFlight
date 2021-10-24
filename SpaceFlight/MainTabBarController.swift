//
//  MainTabBarController.swift
//  SpaceFlight
//
//  Created by Diego Bustamante on 10/16/21.
//

import UIKit

class MainTabBarController : UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpControllers()
        setupTabBarProperties()
    }
    
    /// Overrides the default UITabBar properties to a custom propertie
    fileprivate func setupTabBarProperties() {
        tabBar.tintColor = UIColor.systemRed
    }
    
    /// Creates the viewControllers for the tabbar for `SpaceFlightViewController` and `ResourcesViewController`
    fileprivate func setUpControllers() {
        let home = SpaceFlightViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let resources = ResourcesViewController(style: .insetGrouped)
        let homeViewController = templateNavController(unselectedImage: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"),rootViewController: home)
        let resourcesViewController = templateNavController(unselectedImage: UIImage(systemName: "gear"), selectedImage: UIImage(systemName: "gear.fill"), rootViewController: resources)
        viewControllers = [homeViewController, resourcesViewController]
    }
    
    /// Creates a UINavigationController template to insert into the tabbar viewControllers
    /// - Parameters:
    ///   - unselectedImage: The `image` presented on the `tabbar` when the item isnt selected
    ///   - selectedImage: The `image` presented on the `tabbar` when the item is selected
    ///   - rootViewController: The `ViewController` used to wrap into a `UINavigationController`
    /// - Returns: A `UINavigationView` controller from the passed `rootViewController`
    fileprivate func templateNavController(unselectedImage: UIImage?, selectedImage: UIImage?, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let viewNavController = UINavigationController(rootViewController: viewController)
        viewNavController.tabBarItem.image = unselectedImage
        viewNavController.tabBarItem.selectedImage = selectedImage
        return viewNavController
    }
}
