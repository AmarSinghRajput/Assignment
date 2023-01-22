//
//  EmployeeListViewController.swift
//  Sample
//
//  Created by Amar Kumar Singh on 20/01/23.
//

import UIKit
import RxSwift
import RxCocoa

class EmployeeListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel : EmployeeListViewModel?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let vm = self.viewModel else { return }
        vm.setupBinding()
        tableView.reloadData()
    }
    
    func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "EmployeeTableViewCell", bundle: nil), forCellReuseIdentifier: "EmployeeCell")
        guard let vm = self.viewModel else { return }
        let addButton = UIButton(type: .system)
        addButton.setTitle("Add Employee", for: .normal)
        //        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addButton.rx.tap
            .bind(to: vm.addEmployeeBtnTap)
            .disposed(by: disposeBag)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addButton)
    }
}

extension EmployeeListViewController : UITableViewDelegate , UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let vm = self.viewModel else { return 0 }
        return vm.employeeList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeCell", for: indexPath) as! EmployeeTableViewCell
        guard let vm = self.viewModel else { return UITableViewCell() }
        cell.setupCell(using: vm.employeeList.value[indexPath.row])
        return cell
    }
}
