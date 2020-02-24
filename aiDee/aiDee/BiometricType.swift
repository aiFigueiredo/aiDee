//
//  BiometricType.swift
//  aiDee
//
//  Created by Jose Miguel Figueiredo on 22/02/2020.
//  Copyright © 2020 Jose Miguel Figueiredo. All rights reserved.
//

import LocalAuthentication

/// Enum that represents the Biometric option available on a devide:
/// touchId, faceId or none if unavailable
public enum BiometricType {
    case none
    case touchID
    case faceID
}

extension BiometricType {
    public init(biometricType: LABiometryType) {
        switch biometricType {
        case .touchID:
            self = .touchID
        case .faceID:
            self = .faceID
        default:
            self = .none
        }
    }
}
