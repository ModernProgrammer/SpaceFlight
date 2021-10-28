//
//  MainTabBarController.swift
//  SpaceFlight
//
//  Created by Diego Bustamante on 10/16/21.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpControllers()
        setupTabBarProperties()
    }
}

// MARK: - UI Functions
extension MainTabBarController {
    /// Overrides the default UITabBar properties to a custom propertie
    fileprivate func setupTabBarProperties() {
        tabBar.tintColor = UIColor.systemRed
    }
}

// MARK: - Setup ViewController Functions
extension MainTabBarController {
    /// Creates the viewControllers for the tabbar for `SpaceFlightViewController` and `ResourcesViewController`
    fileprivate func setUpControllers() {
        let home = SpaceFlightViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let houseIcon = UIImage(systemName: "house")
        let houseIconFill = UIImage(systemName: "house.fill")
        let resources = ResourcesViewController(style: .insetGrouped)
        let gearIcon = UIImage(systemName: "gear")
        let gearIconFill = UIImage(systemName: "gear.fill")
        let homeViewController = templateNavController(rootViewController: home, unselectedImage: houseIcon, selectedImage: houseIconFill)
        let resourcesViewController = templateNavController(rootViewController: resources, unselectedImage: gearIcon, selectedImage: gearIconFill)
        viewControllers = [homeViewController, resourcesViewController]
    }
    
    /// Creates a UINavigationController template to insert into the tabbar viewControllers
    /// - Parameters:
    ///   - unselectedImage: The `image` presented on the `tabbar` when the item isnt selected
    ///   - selectedImage: The `image` presented on the `tabbar` when the item is selected
    ///   - rootViewController: The `ViewController` used to wrap into a `UINavigationController`
    /// - Returns: A `UINavigationView` controller from the passed `rootViewController`
    fileprivate func templateNavController(rootViewController: UIViewController = UIViewController(), unselectedImage: UIImage?, selectedImage: UIImage?) -> UINavigationController {
        let viewController = rootViewController
        let viewNavController = UINavigationController(rootViewController: viewController)
        viewNavController.tabBarItem.image = unselectedImage
        viewNavController.tabBarItem.selectedImage = selectedImage
        return viewNavController
    }
}
