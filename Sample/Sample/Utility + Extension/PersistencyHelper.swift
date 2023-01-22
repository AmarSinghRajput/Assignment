//
//  PersistencyHelper.swift
//  Sample
//
//  Created by Amar Kumar Singh on 19/01/23.
//

import Foundation

class PersistencyManager {
    
    static var shared = PersistencyManager()
    
    private init() {
        
    }
    
    func saveToFile(data: CompaniesModel) {
        
        let encoder = JSONEncoder()

        if let data = try? encoder.encode(data),
           let fileURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("company.json") {
            try? data.write(to: fileURL)
        }
    }
    
    func fetchFromFile() -> CompaniesModel? {
        let decoder = JSONDecoder()
        if let fileURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("company.json"),
           let data = try? Data(contentsOf: fileURL),
           let companyData = try? decoder.decode(CompaniesModel.self, from: data) {
//            print(companyData.companies?.first?.email)
            return companyData
        }
        return nil
    }
}
