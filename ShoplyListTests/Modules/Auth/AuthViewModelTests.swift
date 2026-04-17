//
//  AuthViewModelTests.swift
//  ShoplyListTests
//
//  Created by Maksym Vitovych on 17.04.2026.
//  Copyright © 2026 Shoply. All rights reserved.
//

import Testing
@testable import ShoplyList

@MainActor
struct AuthViewModelTests {
    // MARK: - isFormValid
    @Test func isFormValidReturnsFalseForEmptyEmail() {
        let vm = AuthViewModel(authService: MockAuthService())
        vm.email = ""
        vm.password = "password123"
        #expect(vm.isFormValid == false)
    }

    @Test func isFormValidReturnsFalseForShortPassword() {
        let vm = AuthViewModel(authService: MockAuthService())
        vm.email = "user@example.com"
        vm.password = "short"
        #expect(vm.isFormValid == false)
    }

    @Test func isFormValidReturnsTrueForValidSignInCredentials() {
        let vm = AuthViewModel(authService: MockAuthService())
        vm.email = "user@example.com"
        vm.password = "password123"
        #expect(vm.isFormValid == true)
    }

    @Test func isFormValidReturnsTrueForMatchingSignUpPasswords() {
        let vm = AuthViewModel(authService: MockAuthService())
        vm.mode = .signUp
        vm.email = "user@example.com"
        vm.password = "password123"
        vm.confirmPassword = "password123"
        #expect(vm.isFormValid == true)
    }

    @Test func isFormValidReturnsFalseForMismatchedSignUpPasswords() {
        let vm = AuthViewModel(authService: MockAuthService())
        vm.mode = .signUp
        vm.email = "user@example.com"
        vm.password = "password123"
        vm.confirmPassword = "different1"
        #expect(vm.isFormValid == false)
    }

    // MARK: - isSignUpMode
    @Test func isSignUpModeReturnsFalseInSignInMode() {
        let vm = AuthViewModel(authService: MockAuthService())
        vm.mode = .signIn
        #expect(vm.isSignUpMode == false)
    }

    @Test func isSignUpModeReturnsTrueInSignUpMode() {
        let vm = AuthViewModel(authService: MockAuthService())
        vm.mode = .signUp
        #expect(vm.isSignUpMode == true)
    }

    // MARK: - toggleMode
    @Test func toggleModeFlipsFromSignInToSignUp() {
        let vm = AuthViewModel(authService: MockAuthService())
        vm.mode = .signIn
        vm.toggleMode()
        #expect(vm.mode == .signUp)
    }

    @Test func toggleModeFlipsFromSignUpToSignIn() {
        let vm = AuthViewModel(authService: MockAuthService())
        vm.mode = .signUp
        vm.toggleMode()
        #expect(vm.mode == .signIn)
    }

    @Test func toggleModeClearsPasswordFields() {
        let vm = AuthViewModel(authService: MockAuthService())
        vm.password = "secret123"
        vm.confirmPassword = "secret123"
        vm.toggleMode()
        #expect(vm.password == "")
        #expect(vm.confirmPassword == "")
    }

    @Test func toggleModeClearsErrorMessage() {
        let vm = AuthViewModel(authService: MockAuthService())
        vm.errorMessage = "Some error"
        vm.toggleMode()
        #expect(vm.errorMessage == nil)
    }

    // MARK: - submitTapped validation errors

    @Test func submitTappedSetsPasswordTooShortErrorInSignInMode() async {
        let vm = AuthViewModel(authService: MockAuthService())
        vm.email = "user@example.com"
        vm.password = "short"
        await vm.submitTapped()
        #expect(vm.errorMessage == LocalizationConstants.Auth.passwordTooShort)
    }

    @Test func submitTappedSetsPasswordMismatchErrorInSignUpMode() async {
        let vm = AuthViewModel(authService: MockAuthService())
        vm.mode = .signUp
        vm.email = "user@example.com"
        vm.password = "password123"
        vm.confirmPassword = "different1"
        await vm.submitTapped()
        #expect(vm.errorMessage == LocalizationConstants.Auth.passwordMismatch)
    }

    @Test func submitTappedDoesNotCallServiceWhenFormInvalid() async {
        let mock = MockAuthService()
        let vm = AuthViewModel(authService: mock)
        vm.email = ""
        vm.password = "short"
        await vm.submitTapped()
        #expect(mock.signInCallCount == 0)
        #expect(mock.signUpCallCount == 0)
    }

    // MARK: - submitTapped service calls

    @Test func submitTappedCallsSignInWithCorrectCredentials() async {
        let mock = MockAuthService()
        let vm = AuthViewModel(authService: mock)
        vm.email = "user@example.com"
        vm.password = "password123"
        await vm.submitTapped()
        #expect(mock.signInCallCount == 1)
        #expect(mock.capturedSignInEmail == "user@example.com")
        #expect(mock.capturedSignInPassword == "password123")
    }

    @Test func submitTappedCallsSignUpWithCorrectCredentials() async {
        let mock = MockAuthService()
        let vm = AuthViewModel(authService: mock)
        vm.mode = .signUp
        vm.email = "new@example.com"
        vm.password = "password123"
        vm.confirmPassword = "password123"
        await vm.submitTapped()
        #expect(mock.signUpCallCount == 1)
        #expect(mock.capturedSignUpEmail == "new@example.com")
        #expect(mock.capturedSignUpPassword == "password123")
    }

    @Test func submitTappedClearsErrorOnSuccess() async {
        let mock = MockAuthService()
        let vm = AuthViewModel(authService: mock)
        vm.errorMessage = "Previous error"
        vm.email = "user@example.com"
        vm.password = "password123"
        await vm.submitTapped()
        #expect(vm.errorMessage == nil)
    }

    // MARK: - submitTapped error handling

    @Test func submitTappedSetsErrorMessageOnSignInFailure() async {
        let mock = MockAuthService()
        mock.shouldThrowOnSignIn = true
        let vm = AuthViewModel(authService: mock)
        vm.email = "user@example.com"
        vm.password = "password123"
        await vm.submitTapped()
        #expect(vm.errorMessage == MockAuthService.MockError.signIn.localizedDescription)
    }

    @Test func submitTappedSetsErrorMessageOnSignUpFailure() async {
        let mock = MockAuthService()
        mock.shouldThrowOnSignUp = true
        let vm = AuthViewModel(authService: mock)
        vm.mode = .signUp
        vm.email = "user@example.com"
        vm.password = "password123"
        vm.confirmPassword = "password123"
        await vm.submitTapped()
        #expect(vm.errorMessage == MockAuthService.MockError.signUp.localizedDescription)
    }

    @Test func submitTappedResetsLoadingAfterSuccess() async {
        let mock = MockAuthService()
        let vm = AuthViewModel(authService: mock)
        vm.email = "user@example.com"
        vm.password = "password123"
        await vm.submitTapped()
        #expect(vm.isLoading == false)
    }

    @Test func submitTappedResetsLoadingAfterFailure() async {
        let mock = MockAuthService()
        mock.shouldThrowOnSignIn = true
        let vm = AuthViewModel(authService: mock)
        vm.email = "user@example.com"
        vm.password = "password123"
        await vm.submitTapped()
        #expect(vm.isLoading == false)
    }
}
