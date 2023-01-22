//
//  CompanyModel.swift
//  Sample
//
//  Created by Amar Kumar Singh on 19/01/23.
//

import Foundation

struct CompaniesModel: Codable {
    var companies: [Company]?
}

struct Company: Codable {
    var name: String
    var email: String
    var password: String
    var ceoName: String
    var location: String
    var employee: [Employee]?
}

struct Employee: Codable {
    var name: String
    var email: String
    var designation: String
    var department: String
}
