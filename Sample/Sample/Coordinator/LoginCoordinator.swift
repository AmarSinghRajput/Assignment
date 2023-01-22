//
//  LoginCoordinator.swift
//  Sample
//
//  Created by Amar Kumar Singh on 21/01/23.
//

import Foundation
import RxSwift
import UIKit


class LoginCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    let loginBtnTapped = PublishSubject<Void>()
    let registerBtnTapped = PublishSubject<Void>()
    let userAuthenticated = PublishSubject<Void>()
    let disposeBag = DisposeBag()
    unowned let navigationController:UINavigationController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController : LoginViewController = LoginViewController.instantiate()
        let viewModel = LoginViewModel()
        viewModel.registerButtonTapped.bind(to: registerBtnTapped).disposed(by: disposeBag)
        viewModel.userAuthenticated.bind(to: userAuthenticated).disposed(by: disposeBag)
        viewController.viewModel = viewModel
        self.performBindings(viewModel: viewModel)
        self.navigationController.pushViewController(viewController, animated: true)
    }
}

extension LoginCoordinator {
    func performBindings(viewModel: LoginViewModel) {
        userAuthenticated
            .subscribe(onNext: {
                self.navigateToHome()
            })
            .disposed(by: disposeBag)
        
        registerBtnTapped
            .subscribe(onNext: {
                self.navigateToRegister()
            })
            .disposed(by: disposeBag)
        
    }
    
    func navigateToHome() {
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        childCoordinators.append(homeCoordinator)
        homeCoordinator.start()
    }
    
    func navigateToRegister() {
        navigationController.popViewController(animated: true)
    }
}
