//
//  ProfileViewModelTests.swift
//  ShoplyListTests
//
//  Created by Maksym Vitovych on 17.04.2026.
//  Copyright © 2026 Shoply. All rights reserved.
//

import Testing
import Foundation
@testable import ShoplyList

@MainActor
struct ProfileViewModelTests {
    // MARK: - userEmail
    @Test func userEmailReturnsEmailFromService() {
        let mock = MockAuthService()
        mock.currentUserEmail = "user@example.com"
        let vm = ProfileViewModel(authService: mock)
        #expect(vm.userEmail == "user@example.com")
    }

    @Test func userEmailReturnsDashWhenNoEmail() {
        let mock = MockAuthService()
        mock.currentUserEmail = nil
        let vm = ProfileViewModel(authService: mock)
        #expect(vm.userEmail == "—")
    }

    // MARK: - signOutTapped

    @Test func signOutTappedSetsShowSignOutConfirmationToTrue() {
        let vm = ProfileViewModel(authService: MockAuthService())
        #expect(vm.showSignOutConfirmation == false)
        vm.signOutTapped()
        #expect(vm.showSignOutConfirmation == true)
    }

    // MARK: - confirmSignOut
    @Test func confirmSignOutCallsAuthServiceSignOut() {
        let mock = MockAuthService()
        let vm = ProfileViewModel(authService: mock)
        vm.confirmSignOut()
        #expect(mock.signOutCallCount == 1)
    }

    @Test func confirmSignOutDoesNotSetErrorOnSuccess() {
        let mock = MockAuthService()
        let vm = ProfileViewModel(authService: mock)
        vm.confirmSignOut()
        #expect(vm.errorMessage == nil)
    }

    @Test func confirmSignOutSetsErrorMessageOnFailure() {
        let mock = MockAuthService()
        mock.shouldThrowOnSignOut = true
        let vm = ProfileViewModel(authService: mock)
        vm.confirmSignOut()
        #expect(vm.errorMessage == MockAuthService.MockError.signOut.localizedDescription)
    }
}
