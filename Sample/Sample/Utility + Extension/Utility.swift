//
//  Utility.swift
//  Sample
//
//  Created by Amar Kumar Singh on 19/01/23.
//

import Foundation

class UtilityHelper {}

extension String {
    func validateEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: self)
    }
}
