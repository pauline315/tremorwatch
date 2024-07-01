//
//  MainTabbarController.swift
//  TremorWatch
//
//  Created by EMTECH MAC on 26/06/2024.
//

import UIKit





class MainTabbarController: UITabBarController{
    
    let  configuration = UIImage.SymbolConfiguration(weight: .heavy)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabs()
    }
    
    func setupTabs() {
        
        
        viewControllers = [
        createNavigationController(rootViewController: MapViewController(), title: "Maps", image: UIImage(systemName: "map.circle", withConfiguration: configuration)!, selectedImage: UIImage(systemName: "map.circle.fill", withConfiguration: configuration)!),
            
        createNavigationController(rootViewController: SearchViewController(), title: "Search", image: UIImage(systemName: "magnifyingglass.circle", withConfiguration: configuration)!, selectedImage: UIImage(systemName: "magnifyingglass.circle.fill", withConfiguration: configuration)!),
        
        
        ]
    }
    
    func createNavigationController(rootViewController: UIViewController, title: String, image: UIImage, selectedImage: UIImage) -> UIViewController {
        
        let navController = UINavigationController(rootViewController: rootViewController)
        
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.tabBarItem.selectedImage = selectedImage
        navController.navigationBar.prefersLargeTitles = false
        
        navController.navigationItem.title = title
        
        UITabBar.appearance().tintColor = .systemPurple
        UITabBar.appearance().backgroundColor = .white
        
        return navController
    }
}
