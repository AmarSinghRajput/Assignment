//
//  UIViewController+Extensions.swift
//  Sample
//
//  Created by Amar Kumar Singh on 21/01/23.
//

import Foundation
import UIKit

extension UIViewController {
    static func instantiate() -> Self {
        let identifier = String(describing: self)
        let uiStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = uiStoryboard.instantiateViewController(withIdentifier: identifier) as! Self
        
        return viewController
    }
    
    func configureDismissKeyboard() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
    }
    
    @objc private func handleTap(sender: UITapGestureRecognizer? = nil) {
        sender?.view?.endEditing(true)
    }
    
    func presentOnTop(_ viewController: UIViewController, animated: Bool) {
        var topViewController = self
        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }
        topViewController.present(viewController, animated: animated)
    }
    
    func showAlert(title: String, message: String) {
        let viewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        viewController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(viewController, animated: true, completion: nil)
    }
}

