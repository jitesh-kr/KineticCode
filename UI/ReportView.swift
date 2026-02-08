//
//  ReportView.swift
//  KineticCode
//
//  Created by Jitesh Kumar on 07/02/26.
//

import SwiftUI
import Charts

struct ReportView: View {
    let maxAngle: Double
    
    var body: some View {
        VStack {
            Text("Session Summary")
                .font(.title2).bold()
                .padding()
            
            Chart {
                BarMark(
                    x: .value("Metric", "Max ROM"),
                    y: .value("Degrees", maxAngle)
                )
                .foregroundStyle(.blue)
                .annotation(position: .top) {
                    Text("\(Int(maxAngle))°")
                }
            }
            .frame(height: 300)
            .padding()
            
            Text("Great work! Keep pushing your limits.")
                .font(.caption)
        }
    }
}
