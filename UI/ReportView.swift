//
//  ReportView.swift
//  KineticCode
//
//  Created by Jitesh Kumar on 07/02/26.
//

import SwiftUI
import Charts

struct ReportView: View {
    // Optional because it might be used as a standalone tab or a session summary
    var sessionMaxAngle: Double?
    
    // Dummy Data for History
    struct SessionData: Identifiable {
        let id = UUID()
        let date: Date
        let maxROM: Double
    }
    
    let historyData: [SessionData] = [
        SessionData(date: Calendar.current.date(byAdding: .day, value: -6, to: Date())!, maxROM: 85),
        SessionData(date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!, maxROM: 92),
        SessionData(date: Calendar.current.date(byAdding: .day, value: -4, to: Date())!, maxROM: 88),
        SessionData(date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, maxROM: 105),
        SessionData(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, maxROM: 110),
        SessionData(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, maxROM: 115),
        SessionData(date: Date(), maxROM: 120)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // If presented after a session, show specific feedback
                    if let maxAngle = sessionMaxAngle {
                        VStack(spacing: 8) {
                            Text("Session Complete!")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text("You reached \(Int(maxAngle))° ROM")
                                .font(.title3)
                                .foregroundStyle(.blue)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(16)
                    }
                    
                    // ROM History Chart
                    VStack(alignment: .leading, spacing: 16) {
                        Text("ROM History (Last 7 Days)")
                            .font(.headline)
                        
                        Chart {
                            ForEach(historyData) { session in
                                LineMark(
                                    x: .value("Date", session.date, unit: .day),
                                    y: .value("Max ROM", session.maxROM)
                                )
                                .interpolationMethod(.catmullRom)
                                .symbol(by: .value("Date", session.date))
                                
                                AreaMark(
                                    x: .value("Date", session.date, unit: .day),
                                    y: .value("Max ROM", session.maxROM)
                                )
                                .interpolationMethod(.catmullRom)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.blue.opacity(0.3), .clear],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                            }
                            
                            if let maxAngle = sessionMaxAngle {
                                PointMark(
                                    x: .value("Date", Date(), unit: .day),
                                    y: .value("Max ROM", maxAngle)
                                )
                                .foregroundStyle(.green)
                                .annotation(position: .top) {
                                    Text("New Best!")
                                        .font(.caption2)
                                        .foregroundStyle(.green)
                                }
                            }
                        }
                        .frame(height: 250)
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                    
                    // Stats Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        StatBox(title: "Average ROM", value: "102°", icon: "chart.pie.fill", color: .purple)
                        StatBox(title: "Total Sessions", value: "12", icon: "figure.play", color: .orange)
                        StatBox(title: "Best Streak", value: "5 Days", icon: "flame.fill", color: .red)
                        StatBox(title: "Total Time", value: "45m", icon: "clock.fill", color: .teal)
                    }
                }
                .padding()
            }
            .navigationTitle("Reports")
            .background(Color(uiColor: .systemGroupedBackground))
        }
    }
}

struct StatBox: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    ReportView(sessionMaxAngle: 125)
}
