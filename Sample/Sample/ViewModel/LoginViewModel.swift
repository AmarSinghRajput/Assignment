//
//  LoginViewModel.swift
//  Sample
//
//  Created by Amar Kumar Singh on 20/01/23.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel {
    
    var email = BehaviorRelay<String?>(value: "")
    var password = BehaviorRelay<String?>(value: "")
    let loginBtnTapped = PublishSubject<Void>()
    let registerButtonTapped = PublishSubject<Void>()
    let userAuthenticated = PublishSubject<Void>()
    let userAuthenticationFailed = PublishSubject<String>()
    var isValidForm: Observable<Bool> {
        // check if name is valid not empty
        // valid email
        // password >= N
        return Observable.combineLatest(email, password) { email, password in
            return email!.validateEmail() && (password!.count > 5)
        }
    }
    let disposeBag = DisposeBag()
    
    init() {
        setupBinding()
    }
    
    func setupBinding() {
        
        loginBtnTapped
            .subscribe(onNext: {
                var companyData: CompaniesModel!
                if PersistencyManager.shared.fetchFromFile() != nil {
                    companyData = PersistencyManager.shared.fetchFromFile()
                    if let companies = companyData.companies?.filter({ $0.email == self.email.value && self.password.value == $0.password }), companies.count > 0 {
                        //saving session of companies.first!
                        UserDefaults.standard.set(self.email.value, forKey: "email")
                        UserDefaults.standard.synchronize()
                        self.userAuthenticated.onNext(())
                    }else {
                        self.userAuthenticationFailed.onNext("Company not found or wrong credentials")
                    }
                }else {
                    self.userAuthenticationFailed.onNext("Register any company first")
                }
            })
            .disposed(by: disposeBag)
        
        registerButtonTapped
            .subscribe(onNext: {
            })
            .disposed(by: disposeBag)
    }
}
