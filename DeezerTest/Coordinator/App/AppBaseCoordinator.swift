//
//  AppBaseCoordinator.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 23/06/22.
//

import Foundation

protocol AppBaseCoordinator: Coordinator {
    var homeCoordinator: HomeBaseCoordinator { get }
    var searchCoordinator: SearchBaseCoordinator { get }
    func moveTo(flow: CoordinatorType)
}

protocol HomeBaseCoordinated {
    var coordinator: HomeBaseCoordinator? { get }
}

protocol SearchBaseCoordinated {
    var coordinator: SearchBaseCoordinator? { get }
}
