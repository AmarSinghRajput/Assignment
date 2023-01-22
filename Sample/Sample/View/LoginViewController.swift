//
//  LoginViewController.swift
//  Sample
//
//  Created by Amar Kumar Singh on 20/01/23.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var loginbtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    var viewModel : LoginViewModel?
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
        self.navigationItem.title = "Company Login"
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
        emailTextfield.rx.text.bind(to: vm.email).disposed(by: disposeBag)
        passwordTextfield.rx.text.bind(to: vm.password).disposed(by: disposeBag)
        loginbtn.rx.tap.bind(to: vm.loginBtnTapped).disposed(by: disposeBag)
        registerBtn.rx.tap.bind(to: vm.registerButtonTapped).disposed(by: disposeBag)
        
        emailTextfield.rx.controlEvent([.allEditingEvents]).asObservable() // publisher
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self,
                      let isEmailValid = self.emailTextfield.text?.validateEmail() else { return }
                self.emailTextfield.layer.borderColor = isEmailValid ? UIColor.green.cgColor : UIColor.red.cgColor
                
            })
            .disposed(by: disposeBag)
        
        passwordTextfield.rx.controlEvent([.allEditingEvents]).asObservable()
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                let isPasswordValid = self.passwordTextfield.text?.count ?? 0 > 4
                self.passwordTextfield.layer.borderColor = isPasswordValid ? UIColor.green.cgColor : UIColor.red.cgColor
                
            })
            .disposed(by: disposeBag)
        
        vm.userAuthenticationFailed
            .subscribe(onNext: { [weak self] response in
                guard let `self` = self else { return }
                self.showAlert(title: response, message: "")
            })
            .disposed(by: disposeBag)
        vm.isValidForm.bind(to: loginbtn.rx.isEnabled).disposed(by: disposeBag)
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
