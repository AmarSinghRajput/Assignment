//
//  HomeViewModel.swift
//  Sample
//
//  Created by Amar Kumar Singh on 20/01/23.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel {
    
    var companyData = BehaviorRelay<Company?>(value: nil)
    let viewEmployeeBtnTapped = PublishSubject<Void>()
    let disposeBag = DisposeBag()
    
    init() {
        setupBinding()
    }
    
    func setupBinding() {
        let companyData = PersistencyManager.shared.fetchFromFile()
        if let email = UserDefaults.standard.string(forKey: "email") {
            if let companies = companyData?.companies?.filter({ $0.email == email }){
                self.companyData.accept(companies.first!)
            }
        }
        
        viewEmployeeBtnTapped
            .subscribe(onNext: {})
            .disposed(by: disposeBag)
    }
}
