//
//  BiometricError.swift
//  aiDee
//
//  Created by Jose Miguel Figueiredo on 22/02/2020.
//  Copyright © 2019 Jose Figueiredo. All rights reserved.
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
            let bioError = error as? LAError else {
                self = .unknown
                return
        }

        switch bioError {
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
        let description: String 
        switch self {
        case .authenticationFailed:
            description = "There was a problem verifying your identity."
        case .userCancel:
            description = "User Canceled"
        case .userFallback:
            description = "User opted for Password"
        case .biometryNotAvailable:
            description = "Face ID/Touch ID is not available."
        case .biometryNotEnrolled:
            description = "Face ID/Touch ID is not set up."
        case .biometryLockout:
            description = "Face ID/Touch ID is locked."
        case .unknown:
            description = "An unknown error occurred"
        }
        return description
    }
}
