//
//  HomeCoordinator.swift
//  Sample
//
//  Created by Amar Kumar Singh on 21/01/23.
//

import Foundation
import RxSwift
import UIKit


class HomeCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    let viewEmployeeBtnTapped = PublishSubject<Void>()
    let disposeBag = DisposeBag()
    unowned let navigationController:UINavigationController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController : HomeViewController = HomeViewController.instantiate()
        let viewModel = HomeViewModel()
        viewController.viewModel = viewModel
        viewModel.viewEmployeeBtnTapped.bind(to: viewEmployeeBtnTapped).disposed(by: disposeBag)
        self.performBindings(viewModel: viewModel)
        self.navigationController.pushViewController(viewController, animated: true)
    }
}

extension HomeCoordinator {
    func performBindings(viewModel: HomeViewModel) {
        viewEmployeeBtnTapped
            .subscribe(onNext: {
                self.navigateToManageEmployee()
            })
            .disposed(by: disposeBag)
    }
    
    func navigateToManageEmployee() {
        let manageEmployeeCoordinator = EmployeeListCoordinator(navigationController: navigationController)
        childCoordinators.append(manageEmployeeCoordinator)
        manageEmployeeCoordinator.start()
    }
}


