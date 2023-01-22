//
//  RegistrationCoordinator.swift
//  Sample
//
//  Created by Amar Kumar Singh on 20/01/23.
//

import Foundation
import RxSwift
import UIKit


class RegistrationCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    let loginBtnTapped = PublishSubject<Void>()
    let authenticated = PublishSubject<Void>()
    let disposeBag = DisposeBag()
    
    unowned let navigationController:UINavigationController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController : RegistrationViewController = RegistrationViewController.instantiate()
        let viewModel = RegistrationViewModel()
        viewModel.loginBtnTapped.bind(to: loginBtnTapped).disposed(by: disposeBag)
        performBindings(viewModel: viewModel)
        viewController.viewModel = viewModel
        self.navigationController.viewControllers = [viewController]
    }
}

extension RegistrationCoordinator {
    func performBindings(viewModel: RegistrationViewModel) {
        loginBtnTapped
            .subscribe(onNext: {
                self.navigateToLogin()
            })
            .disposed(by: disposeBag)
    }
    
    func navigateToLogin() {
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        childCoordinators.append(loginCoordinator)
        loginCoordinator.start()
    }
}
