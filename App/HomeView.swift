//
//  HomeView.swift
//  KineticCode
//
//  Created by Jitesh Kumar on 07/02/26.
//

import SwiftUI

struct HomeView: View {
    @State private var showGame = false
    @State private var showSettings = false
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header Section
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Welcome Back,")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text("Explorer!")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                        Spacer()
                        
                        // Profile / Settings Button
                        Button(action: {
                            showSettings = true
                        }) {
                            Circle()
                                .fill(Color.blue.opacity(0.1))
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .foregroundStyle(.blue)
                                )
                        }
                    }
                    .padding(.top, 20)
                    .sheet(isPresented: $showSettings) {
                        NavigationStack {
                            List {
                                Section("Appearance") {
                                    Toggle(isOn: $isDarkMode) {
                                        Label("Dark Mode", systemImage: "moon.fill")
                                    }
                                }
                                
                                Section("Account") {
                                    Text("User Profile")
                                    Text("Sign Out")
                                        .foregroundStyle(.red)
                                }
                            }
                            .navigationTitle("Settings")
                            .toolbar {
                                Button("Done") {
                                    showSettings = false
                                }
                            }
                        }
                        .presentationDetents([.medium, .large])
                    }
                    
                    // Hero Card - "Start Session"
                    Button(action: {
                        showGame = true
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 24)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.blue, Color.purple],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Start New Session")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.white)
                                    
                                    Text("Continue your therapy journey")
                                        .font(.subheadline)
                                        .foregroundStyle(.white.opacity(0.9))
                                    
                                    HStack(spacing: 4) {
                                        Text("Play Now")
                                        Image(systemName: "arrow.right")
                                    }
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 16)
                                    .background(.white.opacity(0.2))
                                    .clipShape(Capsule())
                                    .padding(.top, 8)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "figure.play")
                                    .font(.system(size: 60))
                                    .foregroundStyle(.white.opacity(0.8))
                            }
                            .padding(24)
                        }
                        .frame(height: 180)
                    }
                    .buttonStyle(PlainButtonStyle()) // Needed for NavigationLink behavior if used, trying to keep button feel
                    
                    // Stats Grid
                    HStack(spacing: 16) {
                        StatCard(
                            title: "Streak",
                            value: "3 Days",
                            icon: "flame.fill",
                            color: .orange
                        )
                        
                        StatCard(
                            title: "Best ROM",
                            value: "120°",
                            icon: "chart.bar.fill",
                            color: .green
                        )
                    }
                    
                    // Recent Activity Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Recent Activity")
                            .font(.headline)
                            .padding(.leading, 4)
                        
                        ForEach(1...3, id: \.self) { item in
                            HACard(item: item)
                        }
                    }
                }
                .padding()
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationDestination(isPresented: $showGame) {
                GameView()
                    .navigationBarBackButtonHidden(false) // Allow going back
            }
        }
    }
}

// Helper Views
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(color)
                    .font(.title2)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct HACard: View {
    let item: Int
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.blue)
                    .font(.title3)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Session #\(item)")
                    .font(.headline)
                Text("Completed on Feb \(8 + item)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.03), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    HomeView()
}
