//
//  EmployeeTableViewCell.swift
//  Sample
//
//  Created by Amar Kumar Singh on 20/01/23.
//

import UIKit

class EmployeeTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var designation: UILabel!
    @IBOutlet weak var department: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(using employee: Employee) {
        name?.text = "name: " + employee.name
        email?.text = "email: " + employee.email
        designation?.text = "designation: " + employee.designation
        department?.text = "department: " + employee.department
    }
}
