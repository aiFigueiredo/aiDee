//
//  ViewControllerExtension.swift
//  CabyShop
//
//  Created by Jose Miguel Figueiredo on 22/02/2020.
//  Copyright © 2020 Jose Figueiredo. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
