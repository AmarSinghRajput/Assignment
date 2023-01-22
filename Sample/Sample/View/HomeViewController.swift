//
//  HomeViewController.swift
//  Sample
//
//  Created by Amar Kumar Singh on 19/01/23.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var ceoName: UILabel!
    @IBOutlet weak var headquaterLocation: UILabel!
    @IBOutlet weak var addEmployeeBtn: UIButton!
    
    
    var viewModel : HomeViewModel?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupUI()
    }
    
    func setup() {
        guard let vm = self.viewModel else { return }
        addEmployeeBtn.rx.tap.bind(to: vm.viewEmployeeBtnTapped).disposed(by: disposeBag)
    }
    
    func setupUI() {
        self.navigationItem.title = "Company Details"
        guard let vm = self.viewModel else { return }
        vm.companyData
            .subscribe(onNext: { company in
                self.name.text = "Name:  " + (company?.name ?? "")
                self.email.text = "Email:  " + (company?.email ?? "")
                self.ceoName.text = "Ceo Name: " + (company?.ceoName ?? "")
                self.headquaterLocation.text = "Headquater location: " + (company?.location ?? "")
            })
            .disposed(by: disposeBag)
    }
}
