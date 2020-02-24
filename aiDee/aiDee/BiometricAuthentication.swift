//
//  BiometricAuthentication.swift
//  aiDee
//
//  Created by Jose Miguel Figueiredo on 22/02/2020.
//  Copyright © 2019 Jose Figueiredo. All rights reserved.
//

import LocalAuthentication

///
/// Class responsible for interact with LocalAuthentication API for biometric authentication: Touch ID or Face ID.
/// This class contains methods in its API to check availability and perform biometrics authentication with a iOS Device.
///
public class BiometricAuthentication {
    let context: LAContext
    let mainQueue: DispatchQueue

    // MARK: - Public Methods

    /// Initializer for BiometricAuthentication object
    ///
    /// @context: LAContext object defaulted to use initializer the main initializer
    /// @mainQueue: DispatchQueue object defaulted to use main queue
    public init(context: LAContext = LAContext(),
                mainQueue: DispatchQueue = .main) {
        self.context = context
        self.mainQueue = mainQueue
    }

    /// Checks if any biometric solution is available
    /// Returns a Bool representing if biometrics is available or not
    public func isBiometricsAvailable() -> Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }

    /// Check what type of biometric solution is available if any
    /// Returns a BiometricType type with the correct case: .touchId, .faceId or .none if unavailable
    public func biometricType() -> BiometricType {
        let _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch context.biometryType {
        case .none:
            return .none
        case .touchID:
            return .touchID
        case .faceID:
            return .faceID
        @unknown default:
            assert(false, "not supported")
        }
    }

    /// Authenticates user using biometrics
    /// Note that the credentials should be stored in the keychain
    /// @localizedReason: LocalizedSring with reason for requesting biometics authentication
    /// @completioon: Closure with BiometricsResult as a parameter and Void as a return type
    public func authenticateUser(localizedReason: String,
                                 completion: @escaping (BiometricResult) -> Void) {
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
                                                         completion: @escaping (BiometricResult) -> Void) {
        if success {
            completion(.success)
        } else {
            completion(.failure(BiometricError(error: evaluateError)))
        }
    }
}
