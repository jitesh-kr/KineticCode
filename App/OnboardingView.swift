//
//  OnboardingView.swift
//  KineticCode
//
//  Created by Jitesh Kumar on 07/02/26.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("isOnboarding") var isOnboarding: Bool = true
    @State private var currentTab = 0

    // Data model for pages
    struct OnboardingPage {
        let image: String
        let title: String
        let description: String
        let color: Color
    }

    let pages: [OnboardingPage] = [
        OnboardingPage(
            image: "figure.play",
            title: "KineticCode",
            description: "Gamified Physical Therapy for Kids.\nPhysical therapy often fails due to boredom. We make it fun and effective.",
            color: Color(red: 0.85, green: 0.3, blue: 0.7) // Pinkish Purple
        ),
        OnboardingPage(
            image: "figure.arms.open",
            title: "You Are The Controller",
            description: "A game where your body is the controller. The child \"plays\" a character by performing specific therapeutic movements.",
            color: Color(red: 0.3, green: 0.4, blue: 0.9) // Royal Blue
        ),
        OnboardingPage(
            image: "camera.viewfinder",
            title: "Powered by Vision",
            description: "Uses Vision framework's Body Pose Estimation to track joint angles in real-time.",
            color: Color(red: 0.3, green: 0.8, blue: 0.6) // Teal/Green
        ),
        OnboardingPage(
            image: "chart.xyaxis.line",
            title: "Track Progress",
            description: "Generates a \"Range of Motion\" report for the doctor, showing exactly how many degrees of movement were achieved.",
            color: Color(red: 1.0, green: 0.6, blue: 0.2) // Orange
        )
    ]

    var body: some View {
        ZStack {
            // MARK: - Background
            Color.white.ignoresSafeArea()
            
            // Dynamic Gradient Blobs
            ZStack {
                // Blob 1: Top Left
                Circle()
                    .fill(pages[currentTab].color.opacity(0.4))
                    .frame(width: 300, height: 300)
                    .blur(radius: 80)
                    .offset(x: -100, y: -300)
                
                // Blob 2: Bottom Right
                Circle()
                    .fill(pages[currentTab].color.opacity(0.4))
                    .frame(width: 300, height: 300)
                    .blur(radius: 80)
                    .offset(x: 150, y: 300)
                
                // Blob 3: Center Moving
                Circle()
                    .fill(pages[currentTab].color.opacity(0.3))
                    .frame(width: 250, height: 250)
                    .blur(radius: 60)
                    .offset(x: currentTab % 2 == 0 ? -50 : 50, y: currentTab % 2 == 0 ? 0 : 100)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: currentTab)
            }
            .animation(.easeInOut(duration: 1.0), value: currentTab)
            .ignoresSafeArea()

            // Ultra Thin Material Overlay for "Glassmorphism" feel
            Rectangle()
                .fill(.ultraThinMaterial.opacity(0.2))
                .ignoresSafeArea()

            VStack {
                Spacer()
                
                // TabView with Pages
                TabView(selection: $currentTab) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        VStack(spacing: 30) {
                            
                            // Circular Icon Background with Gradient Border
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [.white, .white.opacity(0.9)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 220, height: 220)
                                    .shadow(color: pages[index].color.opacity(0.3), radius: 25, x: 0, y: 15)
                                    .overlay(
                                        Circle()
                                            .stroke(
                                                LinearGradient(
                                                    colors: [pages[index].color.opacity(0.5), .clear],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ),
                                                lineWidth: 2
                                            )
                                    )
                                
                                Image(systemName: pages[index].image)
                                    .font(.system(size: 80))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [pages[index].color, pages[index].color.opacity(0.8)],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                            }
                            .padding(.bottom, 20)
                            .scaleEffect(currentTab == index ? 1.0 : 0.8)
                            .animation(.spring(response: 0.6, dampingFraction: 0.6), value: currentTab)
                            
                            // Text Content
                            VStack(spacing: 16) {
                                Text(pages[index].title)
                                    .font(.system(size: 34, weight: .bold, design: .rounded))
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(Color.primary)
                                
                                Text(pages[index].description)
                                    .font(.system(size: 17, weight: .regular, design: .default))
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(.secondary)
                                    .padding(.horizontal, 32)
                                    .lineSpacing(6)
                            }
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 550)

                Spacer()

                // Bottom Controls
                VStack(spacing: 40) {
                    
                    // Custom Page Indicator with Animation
                    HStack(spacing: 12) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Capsule()
                                .fill(currentTab == index ? pages[currentTab].color : Color.gray.opacity(0.3))
                                .frame(width: currentTab == index ? 30 : 8, height: 8)
                                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: currentTab)
                        }
                    }

                    // Main Action Button with Gradient and Shadow
                    Button(action: {
                        if currentTab < pages.count - 1 {
                            withAnimation {
                                currentTab += 1
                            }
                        } else {
                            isOnboarding = false
                        }
                    }) {
                        Text(currentTab < pages.count - 1 ? "Next" : "Get Started")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                LinearGradient(
                                    colors: [pages[currentTab].color, pages[currentTab].color.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            .shadow(color: pages[currentTab].color.opacity(0.4), radius: 15, x: 0, y: 8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                    }
                    .padding(.horizontal, 30)
                }
                .padding(.bottom, 50)
            }
        }
    }
}

#Preview {
    OnboardingView()
}

