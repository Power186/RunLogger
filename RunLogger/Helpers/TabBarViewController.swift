//
//  TabBarViewController.swift
//  RunLogger
//
//  Created by Scott on 7/15/21.
//

import UIKit

final class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = UIColor.label
        setUpViewControllers()
    }
    
    private func setUpViewControllers() {
        viewControllers = [
            createViewController(for: HomeViewController(), title: "Run", systemImage: "hare"),
            createViewController(for: HistoryViewController(), title: "Logs", systemImage: "clock")
        ]
    }
    
    private func createViewController(for viewController: UIViewController, title: String, systemImage: String) -> UIViewController {
        let iconSymbol = UIImage(systemName: systemImage)
        let selectedSymbol = UIImage(systemName: systemImage, withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
        let tabBarItem = UITabBarItem(title: title, image: iconSymbol, selectedImage: selectedSymbol)
        viewController.tabBarItem = tabBarItem
        return viewController
    }
}
