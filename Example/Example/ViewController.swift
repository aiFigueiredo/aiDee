//
//  ViewController.swift
//  aiDeeExample
//
//  Created by Jose Miguel Figueiredo on 22/02/2020.
//  Copyright © 2020 Jose Figueiredo. All rights reserved.
//

import UIKit
import aiDee

class ViewController: UIViewController {

    // MARK: - BiometricAuthentication Instantiation

    let biometricAuth = BiometricAuthentication()

    // MARK:- IBOutlets declaration

    @IBOutlet weak var biometricsAvailableLabel: UILabel!
    @IBOutlet weak var biometricsTypeLabel: UILabel!

    // MARK: - UIViewController Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLabels()
    }

    // MARK: - Private methods

    private func setUpLabels() {
        self.biometricsAvailableLabel.text = biometricAuth.isBiometricsAvailable() ? "Available" : "Not Available"
        self.biometricsTypeLabel.text = biometricAuth.biometricType().rawValue
    }

    // MARK: - IBAction methods

    @IBAction func authenticateUsingBiometrics(_ sender: Any) {
        biometricAuth.authenticateUser(localizedReason: "Reason for Biometric request") { [weak self] result in
            if case .success = result {
                self?.showAlert(title: "Success", message: "Biometric Auth Successfull")
            } else if case .failure(let error) = result {
                self?.showAlert(title: "Error", message: error.errorDescription)
            }
        }
    }
}
