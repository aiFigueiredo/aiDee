//
//  BiometricAuthentication.swift
//  aiDee
//
//  Created by Jose Miguel Figueiredo on 22/02/2020.
//  Copyright © 2020 Jose Figueiredo. All rights reserved.
//

import LocalAuthentication

public typealias BiometricResult = Result<Void, BiometricError>
public typealias BiometricAuthenticationClosure = (BiometricResult) -> Void

///
/// Class responsible for interact with LocalAuthentication API for biometric authentication: Touch ID or Face ID.
/// This class contains methods in its API to check availability and perform biometrics authentication on a iOS Device.
///
public class BiometricAuthentication {
    let context: LAContext
    let mainQueue: DispatchQueue = .main

    // MARK: - Public Methods

    /// Initializer for BiometricAuthentication object
    /// - Parameters:
    ///   - context: LAContext object defaulted to use initializer the main initializer
    public init(context: LAContext = LAContext()) {
        self.context = context
    }

    /// Checks if any biometric solution is available
    /// Returns a Bool representing if biometrics is available or not
    public func isBiometricsAvailable() -> Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }

    /// Check what type of biometric solution is available if any
    /// Returns a BiometricType type with the correct case: .touchId, .faceId or .none if unavailable
    public func biometricType() -> BiometricType {
        guard isBiometricsAvailable() else {
            return .none
        }

        return BiometricType(biometricType: context.biometryType)
    }

    /// Authenticates user using biometrics
    /// - Parameters:
    ///   - localizedReason: LocalizedSring with reason for requesting biometics authentication
    ///   - completion: BiometricsResult as a parameter and Void as a return type
    public func authenticateUser(localizedReason: String,
                                 completion: @escaping BiometricAuthenticationClosure) {
        guard isBiometricsAvailable() else {
            completion(.failure(.biometryNotAvailable))
            return
        }

        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                               localizedReason: localizedReason) { [weak self] success, evaluateError in
                                self?.mainQueue.async {
                                    self?.handleBiometricAuthenticationCompletion(success: success,
                                    evaluateError: evaluateError,
                                    completion: completion)
                                }

        }
    }

    // MARK: - Private Methods

    private func handleBiometricAuthenticationCompletion(success: Bool,
                                                         evaluateError: Error?,
                                                         completion: @escaping BiometricAuthenticationClosure) {
        if success {
            completion(.success(()))
        } else {
            completion(.failure(BiometricError(error: evaluateError)))
        }
    }
}
