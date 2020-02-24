//
//  MockLAContext.swift
//  aiDeeTests
//
//  Created by Jose Miguel Figueiredo on 23/02/2020.
//  Copyright © 2020 Jose Miguel Figueiredo. All rights reserved.
//

import LocalAuthentication

class MockLAContext: LAContext {
    public var canEvaluatePolicyCalledCount = 0
    public var policyCalled: LAPolicy?
    public var errorCalled: NSErrorPointer?
    public var shouldEvaluateWithSuccess: Bool = false
    public var evaluatePolicyCount = 0
    public var localizedReasonCalled: String?
    public var evaluateSuccess: Bool = false
    public var evaluateError: Error?

    public var mockBiometryType: LABiometryType = .none
    override var biometryType: LABiometryType {
        get { mockBiometryType }
        set { mockBiometryType = newValue }
    }

    override func canEvaluatePolicy(_ policy: LAPolicy, error: NSErrorPointer) -> Bool {
        canEvaluatePolicyCalledCount += 1
        policyCalled = policy
        errorCalled = error
        return shouldEvaluateWithSuccess
    }

    override func evaluatePolicy(_ policy: LAPolicy, localizedReason: String, reply: @escaping (Bool, Error?) -> Void) {
        evaluatePolicyCount += 1
        policyCalled = policy
        localizedReasonCalled = localizedReason
        reply(evaluateSuccess, evaluateError)
    }
}
