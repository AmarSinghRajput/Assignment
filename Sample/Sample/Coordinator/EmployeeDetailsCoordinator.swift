//
//  EmployeeDetailsCoordinator.swift
//  Sample
//
//  Created by Amar Kumar Singh on 21/01/23.
//

import Foundation
import RxSwift
import UIKit


class EmployeeDetailsCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    let deleteEmployeeTap = PublishSubject<Void>()
    let registerEmployeeTap = PublishSubject<Void>()
    let updateEmployeeTap = PublishSubject<Void>()
    let disposeBag = DisposeBag()
    unowned let navigationController:UINavigationController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController : EmployeeDetailsViewController = EmployeeDetailsViewController.instantiate()
        let viewModel = EmployeeDetailsViewModel()
        viewController.viewModel = viewModel
        self.performBindings(viewModel: viewModel)
        viewModel.deleteEmployeeTap.bind(to: deleteEmployeeTap).disposed(by: disposeBag)
        self.navigationController.pushViewController(viewController, animated: true)
    }
}

extension EmployeeDetailsCoordinator {
    func performBindings(viewModel: EmployeeDetailsViewModel) {
        deleteEmployeeTap
            .subscribe(onNext: {
                self.popViewController()
            })
            .disposed(by: disposeBag)
    }
    
    func popViewController() {
        self.navigationController.popViewController(animated: true)
    }
}
