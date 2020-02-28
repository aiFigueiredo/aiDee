//
//  BiometricError.swift
//  aiDee
//
//  Created by Jose Miguel Figueiredo on 22/02/2020.
//  Copyright © 2020 Jose Figueiredo. All rights reserved.
//

import LocalAuthentication

/// Enum that represents a BiometricError the authentication can throw
public enum BiometricError: Error {
    case authenticationFailed
    case userCancel
    case userFallback
    case biometryNotAvailable
    case biometryNotEnrolled
    case biometryLockout
    case unknown
}

extension BiometricError {
    init(error: Error?) {
        guard case let error = error,
            let biometricError = error as? LAError else {
                self = .unknown
                return
        }

        switch biometricError {
        case LAError.authenticationFailed:
            self = .authenticationFailed
        case LAError.userCancel:
            self = .userCancel
        case LAError.userFallback:
            self = .userFallback
        case LAError.biometryNotAvailable:
            self = .biometryNotAvailable
        case LAError.biometryNotEnrolled:
            self = .biometryNotEnrolled
        case LAError.biometryLockout:
            self = .biometryLockout
        default:
            self = .unknown
        }
    }
}

extension BiometricError {
    /// English error description of a certain error
    public var errorDescription: String {
        switch self {
        case .authenticationFailed:
            return "There was a problem verifying your identity."
        case .userCancel:
            return "User Canceled"
        case .userFallback:
            return "User opted for Password"
        case .biometryNotAvailable:
            return "Face ID/Touch ID is not available."
        case .biometryNotEnrolled:
            return "Face ID/Touch ID is not set up."
        case .biometryLockout:
            return "Face ID/Touch ID is locked."
        case .unknown:
            return "An unknown error occurred"
        }
    }
}
