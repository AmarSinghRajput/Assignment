//
//  BaseCoordinator.swift
//  Sample
//
//  Created by Amar Kumar Singh on 20/01/23.
//

import UIKit

public protocol Coordinator : AnyObject {

    var childCoordinators: [Coordinator] { get set }

    // All coordinators will be initilised with a navigation controller
    init(navigationController:UINavigationController)

    func start()
}
