//
//  EmployeeListViewModel.swift
//  Sample
//
//  Created by Amar Kumar Singh on 21/01/23.
//

import Foundation
import RxSwift
import RxCocoa

class EmployeeListViewModel {
    let addEmployeeBtnTap = PublishSubject<Void>()
    var employeeList = BehaviorRelay<[Employee]>(value: [])
    let disposeBag = DisposeBag()
    
    init() {
        setupBinding()
    }
    
    func setupBinding() {
        let companyData = PersistencyManager.shared.fetchFromFile()
        if let email = UserDefaults.standard.string(forKey: "email") {
            if let companies = companyData?.companies?.filter({ $0.email == email }){
                if let employees = companies.first?.employee {
                    self.employeeList.accept(employees)
                }
            }
        }
        
        addEmployeeBtnTap
            .subscribe(onNext: {})
            .disposed(by: disposeBag)
                
    }
}

