//
//  BiometricAuthenticationTests.swift
//  aiDeeTests
//
//  Created by Jose Miguel Figueiredo on 22/02/2020.
//  Copyright © 2020 Jose Miguel Figueiredo. All rights reserved.
//

import XCTest
import LocalAuthentication
@testable import aiDee

class BiometricAuthenticationTests: XCTestCase {
    var sut: BiometricAuthentication!
    var mockLAContext: MockLAContext!

    override func setUp() {
        super.setUp()
        mockLAContext = MockLAContext()
        sut = BiometricAuthentication(context: mockLAContext)
    }

    override func tearDown() {
        mockLAContext = nil
        sut = nil
        super.tearDown()
    }

    func testIsBiometricsAvailable_contextEvaluateWithTrue_BiometricsAvailable() {
        mockLAContext.shouldEvaluateWithSuccess = true

        XCTAssertTrue(sut.isBiometricsAvailable())
        XCTAssertEqual(mockLAContext.canEvaluatePolicyCalledCount, 1)
        XCTAssertEqual(mockLAContext.policyCalled, .deviceOwnerAuthenticationWithBiometrics)
        XCTAssertNil(mockLAContext.errorCalled ?? "")
    }

    func testIsBiometricsAvailable_contextEvaluateWithFalse_BiometricsNotAvailable() {
        mockLAContext.shouldEvaluateWithSuccess = false

        XCTAssertFalse(sut.isBiometricsAvailable())
        XCTAssertEqual(mockLAContext.canEvaluatePolicyCalledCount, 1)
        XCTAssertEqual(mockLAContext.policyCalled, .deviceOwnerAuthenticationWithBiometrics)
        XCTAssertNil(mockLAContext.errorCalled ?? "")
    }

    private func validateBiometryType(type: LABiometryType,
                                      file: StaticString = #file,
                                      line: UInt = #line) {
        mockLAContext.mockBiometryType = type
        XCTAssertEqual(sut.biometricType(), BiometricType(biometricType: type), file: file, line: line)
        XCTAssertEqual(mockLAContext.canEvaluatePolicyCalledCount, 1, file: file, line: line)
        XCTAssertEqual(mockLAContext.policyCalled, .deviceOwnerAuthenticationWithBiometrics, file: file, line: line)
        XCTAssertNil(mockLAContext.errorCalled ?? "", file: file, line: line)
    }

    func testBiometryType_biometryTypeNone_BiometricTypeNone() {
        validateBiometryType(type: .none)
    }

    func testBiometryType_biometryTypeFaceId_BiometricTypeFaceId() {
        validateBiometryType(type: .faceID)
    }

    func testBiometryType_biometryTypeTouchId_BiometricTypeTouchId() {
        validateBiometryType(type: .touchID)
    }

    func testAuthenticateUser_biometricsUnavailable_failureWithBiometricNotAvailableError() {
        let testString = "testString"
        let expectation = self.expectation(description: "biometricsUnAvailable_failureWithBiometriNotAvailableError")
        mockLAContext.shouldEvaluateWithSuccess = false
        mockLAContext.shouldEvaluateWithSuccess = false

        sut.authenticateUser(localizedReason: testString) { result in
            if case .success = result {
                XCTFail("Biometric Auth Should NOT Succeed")
            } else if case .failure(let error) = result {
                XCTAssertEqual(error, .biometryNotAvailable)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 10.0)
        XCTAssertEqual(mockLAContext.evaluatePolicyCount, 0)
        XCTAssertEqual(mockLAContext.policyCalled, .deviceOwnerAuthenticationWithBiometrics)
        XCTAssertNil(mockLAContext.localizedReasonCalled)
    }

    private func validateAuthenticateUser_biometricsAvailableAndFailureInEvaluatePolicy(_ error: Error?,
                                                                                        biometricError: BiometricError,
                                                                                        file: StaticString = #file,
                                                                                        line: UInt = #line) {
        let testString = "testString"
        let expectation = self.expectation(description: "failureInEvaluatePolicy_failureWithUnknownError")
        mockLAContext.evaluateSuccess = false
        mockLAContext.evaluateError = error
        mockLAContext.shouldEvaluateWithSuccess = true

        sut.authenticateUser(localizedReason: testString) { result in
            if case .success = result {
                XCTFail("Biometric Auth Should NOT Succeed", file: file, line: line)
            } else if case .failure(let error) = result {
                XCTAssertEqual(error, biometricError, file: file, line: line)
                XCTAssertEqual(error.errorDescription, biometricError.errorDescription, file: file, line: line)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 10.0)
        XCTAssertEqual(mockLAContext.evaluatePolicyCount, 1, file: file, line: line)
        XCTAssertEqual(mockLAContext.policyCalled, .deviceOwnerAuthenticationWithBiometrics, file: file, line: line)
        XCTAssertEqual(mockLAContext.localizedReasonCalled, testString, file: file, line: line)
    }

    func testAuthenticateUser_biometricsAvailableAndFailureInEvaluatePolicy_failureWithUnknownError() {
        let error = NSError(domain: "testDomain", code: 1, userInfo: nil)
        validateAuthenticateUser_biometricsAvailableAndFailureInEvaluatePolicy(error,
                                                                               biometricError: .unknown)
    }

    func testAuthenticateUser_biometricsAvailableAndFailureInEvaluatePolicy_failureWithAuthenticationFailed() {
        let error = NSError(domain: LAError.errorDomain, code: Int(kLAErrorAuthenticationFailed), userInfo: nil)
        validateAuthenticateUser_biometricsAvailableAndFailureInEvaluatePolicy(error,
                                                                               biometricError: .authenticationFailed)
    }

    func testAuthenticateUser_biometricsAvailableAndFailureInEvaluatePolicy_failureWithUserCanceled() {
        let error = NSError(domain: LAError.errorDomain, code: Int(kLAErrorUserCancel), userInfo: nil)
        validateAuthenticateUser_biometricsAvailableAndFailureInEvaluatePolicy(error,
                                                                               biometricError: .userCancel)
    }

    func testAuthenticateUser_biometricsAvailableAndFailureInEvaluatePolicy_failureWithUserFallback() {
        let error = NSError(domain: LAError.errorDomain, code: Int(kLAErrorUserFallback), userInfo: nil)
        validateAuthenticateUser_biometricsAvailableAndFailureInEvaluatePolicy(error,
                                                                               biometricError: .userFallback)
    }

    func testAuthenticateUser_biometricsAvailableAndFailureInEvaluatePolicy_failureWithBiometryNotAvailable() {
        let error = NSError(domain: LAError.errorDomain, code: Int(kLAErrorBiometryNotAvailable), userInfo: nil)
        validateAuthenticateUser_biometricsAvailableAndFailureInEvaluatePolicy(error,
                                                                               biometricError: .biometryNotAvailable)
    }

    func testAuthenticateUser_biometricsAvailableAndFailureInEvaluatePolicy_failureWithBiometryNotEnrolled() {
        let error = NSError(domain: LAError.errorDomain, code: Int(kLAErrorBiometryNotEnrolled), userInfo: nil)
        validateAuthenticateUser_biometricsAvailableAndFailureInEvaluatePolicy(error,
                                                                               biometricError: .biometryNotEnrolled)
    }

    func testAuthenticateUser_biometricsAvailableAndFailureInEvaluatePolicy_failureWithBiometryLockdown() {
        let error = NSError(domain: LAError.errorDomain, code: Int(kLAErrorBiometryLockout), userInfo: nil)
        validateAuthenticateUser_biometricsAvailableAndFailureInEvaluatePolicy(error,
                                                                               biometricError: .biometryLockout)
    }

    func testAuthenticateUser_biometricsAvailableAndFailureInEvaluatePolicy_failureWithUnknownLAError() {
        let error = NSError(domain: LAError.errorDomain, code: Int(kLAErrorNotInteractive), userInfo: nil)
        validateAuthenticateUser_biometricsAvailableAndFailureInEvaluatePolicy(error,
                                                                               biometricError: .unknown)
    }

    func testAuthenticateUser_evaluatePolicySuccessfull() {
        let testString = "testString"
        let expectation = self.expectation(description: "failureInEvaluatePolicy_failureWithUnknownError")
        mockLAContext.evaluateSuccess = true
        mockLAContext.evaluateError = nil
        mockLAContext.shouldEvaluateWithSuccess = true

        sut.authenticateUser(localizedReason: testString) { result in
            if case .success = result {
                expectation.fulfill()
            } else {
                XCTFail("Biometric Auth Should NOT Fail")
            }
        }

        wait(for: [expectation], timeout: 10.0)
        XCTAssertEqual(mockLAContext.evaluatePolicyCount, 1)
        XCTAssertEqual(mockLAContext.policyCalled, .deviceOwnerAuthenticationWithBiometrics)
        XCTAssertEqual(mockLAContext.localizedReasonCalled, testString)
    }
}
