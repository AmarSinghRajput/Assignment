//
//  EmployeeDetailsViewModel.swift
//  Sample
//
//  Created by Amar Kumar Singh on 21/01/23.
//

import Foundation
import RxSwift
import RxCocoa

class EmployeeDetailsViewModel {
    
    // Properties
    var name = BehaviorRelay<String?>(value: "")
    var email = BehaviorRelay<String?>(value: "")
    var designation = BehaviorRelay<String?>(value: "")
    var department = BehaviorRelay<String?>(value: "")
    let registerBtnTapped = PublishSubject<Void>()
    let registrationSucess = PublishSubject<String>()
    let registrationFailure = PublishSubject<String>()
    
    let deleteEmployeeTap = PublishSubject<Void>()
    let updateEmployeeTap = PublishSubject<Void>()
    let disposeBag = DisposeBag()
    var isValidForm: Observable<Bool> {
        // check if name is valid not empty
        // valid email
        // password >= N
        return Observable.combineLatest(name, email, designation, department) { name, email, designation, department in
            
            return (name != "") && email!.validateEmail() && (designation != "") && (department != "")
        }
    }
    
    init() {
        setupBinding()
    }
    
    func setupBinding() {
        registerBtnTapped
            .subscribe(onNext: {
                
                let newEmp = Employee(name: self.name.value ?? "", email: self.email.value ?? "", designation: self.designation.value ?? "", department: self.department.value ?? "")
                //comapny data
                var companyData = PersistencyManager.shared.fetchFromFile()
                
                companyData!.companies = companyData!.companies.map { companies in
                    var companiesTemp = companies
                    companiesTemp = companiesTemp.map { company in
                        var comp = company
                        if let email = UserDefaults.standard.string(forKey: "email") {
                            if email == company.email {
                                if comp.employee != nil {
                                    comp.employee?.append(newEmp)
                                }else {
                                    comp.employee = [newEmp]
                                }
                                return comp
                            }
                        }
                        return comp
                    }
                    return companiesTemp
                }
                
                PersistencyManager.shared.saveToFile(data: companyData!)
                self.registrationSucess.onNext("employee registered successfully")
            })
            .disposed(by: disposeBag)
        
        deleteEmployeeTap
            .subscribe(onNext: {
                //comapny data
                var companyData = PersistencyManager.shared.fetchFromFile()
                
                companyData!.companies = companyData!.companies.map { companies in
                    var companiesTemp = companies
                    companiesTemp = companiesTemp.map { company in
                        var comp = company
                        if let email = UserDefaults.standard.string(forKey: "email") {
                            if email == company.email {
                                if comp.employee != nil {
                                    comp.employee?.removeAll{ $0.email == email }
                                }
                                return comp
                            }
                        }
                        return comp
                    }
                    return companiesTemp
                }
                
                PersistencyManager.shared.saveToFile(data: companyData!)
            })
            .disposed(by: disposeBag)
        
        updateEmployeeTap
            .subscribe(onNext: {
                //comapny data
                var companyData = PersistencyManager.shared.fetchFromFile()
                
                companyData!.companies = companyData!.companies.map { companies in
                    var companiesTemp = companies
                    companiesTemp = companiesTemp.map { company in
                        var comp = company
                        if let savedEmail = UserDefaults.standard.string(forKey: "email") {
                            if savedEmail == company.email {
                                comp.employee = comp.employee?.map { employee in
                                    var updatedEmployee = employee
                                    if employee.email == self.email.value ?? "" {
                                        updatedEmployee.name = self.name.value ?? ""
                                        updatedEmployee.email = self.name.value ?? ""
                                        updatedEmployee.designation = self.name.value ?? ""
                                        updatedEmployee.department = self.name.value ?? ""
                                    }
                                    return updatedEmployee
                                }
                                return comp
                            }
                        }
                        return comp
                    }
                    return companiesTemp
                }
                
                PersistencyManager.shared.saveToFile(data: companyData!)
            })
            .disposed(by: disposeBag)
    }
}

