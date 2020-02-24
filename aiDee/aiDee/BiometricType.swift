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
public enum BiometricType: String {
    case none = "Not Available"
    case touchID = "Touch Id"
    case faceID = "Face Id"
}

extension BiometricType {
    public init(biometricType: LABiometryType) {
        switch biometricType {
        case LABiometryType.touchID:
            self = .touchID
        case LABiometryType.faceID:
            self = .faceID
        default:
            self = .none
        }
    }
}
