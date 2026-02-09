//
//  MainTabView.swift
//  KineticCode
//
//  Created by Jitesh Kumar on 07/02/26.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            ReportView() // Standalone report tab
                .tabItem {
                    Label("Reports", systemImage: "chart.bar.xaxis")
                }
        }
        .tint(.blue)
    }
}

#Preview {
    MainTabView()
}
