//
//  EmployeeDetailsViewController.swift
//  Sample
//
//  Created by Amar Kumar Singh on 20/01/23.
//

import UIKit
import RxSwift
import RxCocoa

class EmployeeDetailsViewController: UIViewController {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var designation: UITextField!
    @IBOutlet weak var department: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    
    var viewModel : EmployeeDetailsViewModel?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        guard let vm = self.viewModel else { return }
        name.rx.text.bind(to: vm.name).disposed(by: disposeBag)
        email.rx.text.bind(to: vm.email).disposed(by: disposeBag)
        designation.rx.text.bind(to: vm.designation).disposed(by: disposeBag)
        department.rx.text.bind(to: vm.department).disposed(by: disposeBag)
        registerBtn.rx.tap.bind(to: vm.registerBtnTapped).disposed(by: disposeBag)
        vm.registrationSucess
            .subscribe(onNext: { [weak self] response in
                guard let `self` = self else { return }
                self.showAlert(title: response, message: "")
            })
            .disposed(by: disposeBag)
        vm.registrationFailure
            .subscribe(onNext: { [weak self] response in
                guard let `self` = self else { return }
                self.showAlert(title: response, message: "")
            })
            .disposed(by: disposeBag)
    }
}
