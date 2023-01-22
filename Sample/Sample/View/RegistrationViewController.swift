//
//  RegistrationViewController.swift
//  Sample
//
//  Created by Amar Kumar Singh on 17/01/23.
//

import UIKit
import RxSwift
import RxCocoa


class RegistrationViewController: UIViewController {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var ceoName: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    var viewModel : RegistrationViewModel?
    var emailSubject = BehaviorRelay<String?>(value: "")
    let disposeBag = DisposeBag()
    
    var isValidEmail: Observable<Bool> {
        return emailSubject.map { $0!.validateEmail() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupView()
    }
    
    func setupView() {
        self.navigationItem.title = "Company Registration"
        registerBtn.setTitleColor(.gray, for: .disabled)
        stackView.subviews.forEach { element in
            if element is UITextField {
                element.layer.borderWidth = 0.5
                element.clipsToBounds = true
                element.layer.cornerRadius = 5
                element.layer.borderColor = UIColor.lightGray.cgColor
            }
        }
    }
    
    func setup() {
        guard let vm = self.viewModel else { return }
        name.rx.text.bind(to: vm.name).disposed(by: disposeBag)
        email.rx.text.bind(to: vm.email).disposed(by: disposeBag)
        password.rx.text.bind(to: vm.password).disposed(by: disposeBag)
        ceoName.rx.text.bind(to: vm.ceoName).disposed(by: disposeBag)
        location.rx.text.bind(to: vm.headquaterLocation).disposed(by: disposeBag)
        loginButton.rx.tap.bind(to: vm.loginBtnTapped).disposed(by: disposeBag)
        registerBtn.rx.tap.bind(to: vm.registerBtnTapped).disposed(by: disposeBag)
        
        name.rx.controlEvent([.allEditingEvents]).asObservable()
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                let isNameValid = self.name.text?.count != 0
                self.name.layer.borderColor = isNameValid ? UIColor.green.cgColor : UIColor.red.cgColor
                
            })
            .disposed(by: disposeBag)
        
        email.rx.controlEvent([.allEditingEvents]).asObservable() // publisher
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self,
                      let isEmailValid = self.email.text?.validateEmail() else { return }
                self.email.layer.borderColor = isEmailValid ? UIColor.green.cgColor : UIColor.red.cgColor
                
            })
            .disposed(by: disposeBag)
        
        password.rx.controlEvent([.allEditingEvents]).asObservable()
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                let isPasswordValid = self.password.text?.count ?? 0 > 5
                self.password.layer.borderColor = isPasswordValid ? UIColor.green.cgColor : UIColor.red.cgColor
                
            })
            .disposed(by: disposeBag)
        
        vm.isValidForm.bind(to: registerBtn.rx.isEnabled).disposed(by: disposeBag)
        vm.registrationFailed
            .subscribe(onNext: { [weak self] errorMessage in
                guard let `self` = self else { return }
                self.showAlert(title: errorMessage, message: "")
            })
            .disposed(by: disposeBag)
        vm.registrationSucess
            .subscribe(onNext: { [weak self] response in
                guard let `self` = self else { return }
                self.showAlert(title: response, message: "")
            })
            .disposed(by: disposeBag)
    }    
}

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
