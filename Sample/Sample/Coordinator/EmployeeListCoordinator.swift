//
//  EmployeeListCoordinator.swift
//  Sample
//
//  Created by Amar Kumar Singh on 21/01/23.
//

import Foundation
import RxSwift
import UIKit


class EmployeeListCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    
    unowned let navigationController:UINavigationController
    let addEmployeeBtnTap = PublishSubject<Void>()
    let disposeBag = DisposeBag()
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController : EmployeeListViewController = EmployeeListViewController.instantiate()
        let viewModel = EmployeeListViewModel()
        viewController.viewModel = viewModel
        viewModel.addEmployeeBtnTap.bind(to: addEmployeeBtnTap).disposed(by: disposeBag)
        self.performBindings(viewModel: viewModel)
        self.navigationController.pushViewController(viewController, animated: true)
    }
}

extension EmployeeListCoordinator {
    func performBindings(viewModel: EmployeeListViewModel) {
        addEmployeeBtnTap
            .subscribe(onNext: {
                self.navigateToAddEmployee()
            })
            .disposed(by: disposeBag)
    }
    
    // Navigate to next page
    func navigateToAddEmployee() {
        let employeeDetailsCoordinator = EmployeeDetailsCoordinator(navigationController: navigationController)
        childCoordinators.append(employeeDetailsCoordinator)
        employeeDetailsCoordinator.start()
    }
}
