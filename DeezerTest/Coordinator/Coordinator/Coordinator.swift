//
//  Coordinator.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 20/06/22.
//

import Foundation
import UIKit

// MARK: - Coordinator

protocol FlowCoordinator: AnyObject {
    var parentCoordinator: AppBaseCoordinator? { get set }
}

protocol Coordinator: FlowCoordinator {
    
    var rootViewController: UIViewController { get set }
    var childCoordinators: [Coordinator] { get set }
    func didFinish(_ child: Coordinator)
    func start() -> UIViewController
}

// MARK: - Extension Coordinator

extension Coordinator {
    
    func removeChild(_ child: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { coordinator -> Bool in
            return child === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }
    
    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeAllChildCoordinatorsWith<T>(type: T.Type) {
        childCoordinators = childCoordinators.filter { $0 is T  == false }
    }
    
    func removeAllChildCoordinators() {
        childCoordinators.removeAll()
    }
    
    var navigationRootViewController: UINavigationController? {
        get {
            (rootViewController as? UINavigationController)
        }
    }

    func resetToRoot() -> Self {
        navigationRootViewController?.popToRootViewController(animated: false)
        return self
    }
}
