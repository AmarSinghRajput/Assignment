//
//  RegistrationViewModel.swift
//  Sample
//
//  Created by Amar Kumar Singh on 17/01/23.
//

import Foundation
import RxSwift
import RxCocoa

class RegistrationViewModel {
    
    // Properties
    var name = BehaviorRelay<String?>(value: "")
    var email = BehaviorRelay<String?>(value: "")
    var password = BehaviorRelay<String?>(value: "")
    var ceoName = BehaviorRelay<String?>(value: "")
    var headquaterLocation = BehaviorRelay<String?>(value: "")
    let disposeBag = DisposeBag()
    let loginBtnTapped = PublishSubject<Void>()
    let registerBtnTapped = PublishSubject<Void>()
    let registrationFailed = PublishSubject<String>()
    let registrationSucess = PublishSubject<String>()
    
    var isValidForm: Observable<Bool> {
        // check if name is valid not empty
        // valid email
        // password >= N
        return Observable.combineLatest(name, email, password, ceoName, headquaterLocation) { name, email, password, ceoName, headquaterLocation in
            
            return (name != "") && email!.validateEmail() && (password!.count > 5)
        }
    }
    
    init() {
        setupBinding()
    }
    
    func setupBinding() {
        loginBtnTapped
            .subscribe(onNext: {})
            .disposed(by: disposeBag)
        
        registerBtnTapped
            .subscribe(onNext: {
                let newCompany = Company(name: self.name.value!, email: self.email.value!, password: self.password.value!, ceoName: self.ceoName.value ?? "", location: self.headquaterLocation.value ?? "")
                
                var companyData: CompaniesModel!
                if PersistencyManager.shared.fetchFromFile() != nil {
                    companyData = PersistencyManager.shared.fetchFromFile()
                    if companyData.companies?.filter({ $0.email == self.email.value }).count == 0 {
                        companyData?.companies?.append(newCompany)
                    }else {
                        self.registrationFailed.onNext("Company Already registered")
                    }
                }else {
                    companyData = CompaniesModel(companies: [newCompany])
                }
                
                PersistencyManager.shared.saveToFile(data: companyData)
                self.registrationSucess.onNext("Company registered successfully")
            })
            .disposed(by: disposeBag)
    }
}
