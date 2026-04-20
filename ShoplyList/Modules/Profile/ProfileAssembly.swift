//
//  ProfileAssembly.swift
//  ShoplyList
//
//  Created by Maksym Vitovych on 10.04.2026.
//  Copyright © 2026 Shoply. All rights reserved.
//

import SwiftUI

struct ProfileAssembly {
    func make(authService: AuthService) -> some View {
        let viewModel = ProfileViewModel(authService: authService)
        return ProfileView(viewModel: viewModel)
    }
}
