//
//  AuthAssembly.swift
//  ShoplyList
//
//  Created by Maksym Vitovych on 10.04.2026.
//  Copyright © 2026 Shoply. All rights reserved.
//

import SwiftUI

struct AuthAssembly {
    func make(authService: AuthService) -> some View {
        let viewModel = AuthViewModel(authService: authService)
        return AuthView(viewModel: viewModel)
    }
}
