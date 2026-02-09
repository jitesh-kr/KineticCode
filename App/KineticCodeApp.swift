//
//  KineticCodeApp.swift
//  KineticCode
//
//  Created by Jitesh Kumar on 07/02/26.
//

import SwiftUI

@main
struct KineticCodeApp: App {
    @AppStorage("isOnboarding") var isOnboarding: Bool = true
    @AppStorage("isDarkMode") var isDarkMode: Bool = false

    var body: some Scene {
        WindowGroup {
            Group {
                if isOnboarding {
                    OnboardingView()
                } else {
                    MainTabView()
                }
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
