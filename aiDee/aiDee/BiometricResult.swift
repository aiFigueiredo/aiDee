//
//  BiometricResult.swift
//  aiDee
//
//  Created by Jose Miguel Figueiredo on 22/02/2020.
//  Copyright © 2020 Jose Figueiredo. All rights reserved.
//

// Enum that represents a biometric authentication result
// Either success or failure with BiometricError
public enum BiometricResult {
    case success
    case failure(BiometricError)
}
