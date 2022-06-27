//
//  AppCoordinator.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 20/06/22.
//

import Foundation
import UIKit

protocol AppCoordinatorProtocol: Coordinator {
    func showChartsFlow()
    func showSearchFlow()
}

final class AppCoordinator: AppBaseCoordinator {
    
    // MARK: - Properties
    
    var parentCoordinator: AppBaseCoordinator?
    
    lazy var homeCoordinator: HomeBaseCoordinator = HomeCoordinator()
    lazy var searchCoordinator: SearchBaseCoordinator = SearchCoordinator()
    lazy var rootViewController: UIViewController  = MainTabBarController()
    lazy var childCoordinators: [Coordinator] = []
    
    // MARK: - Methods
    
    func start() -> UIViewController {
        
        let homeViewController = homeCoordinator.start()
        homeCoordinator.parentCoordinator = self
        homeViewController.tabBarItem = UITabBarItem(title: "tab_home".localized, image: UIImage(systemName: "homekit"), tag: 0)
        
        let searchViewController = searchCoordinator.start()
        searchCoordinator.parentCoordinator = self
        searchViewController.tabBarItem = UITabBarItem(title: "tab_search".localized, image: UIImage(systemName: "doc.plaintext"), tag: 1)
        
        (rootViewController as? UITabBarController)?.viewControllers = [homeViewController, searchViewController]
        
        return rootViewController
    }
    
    func moveTo(flow: CoordinatorType) {
        switch flow {
        case .home, .app:
            (rootViewController as? MainTabBarController)?.selectedIndex = 0
        case .search:
            (rootViewController as? MainTabBarController)?.selectedIndex = 1
        }
    }
    
    func didFinish(_ child: Coordinator) {
        removeChild(child)
    }
}
