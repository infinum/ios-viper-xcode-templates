//
//  LoadingOverlayView.swift
//  Viper-Demo
//
//  Created by Hrvoje Hrvoić on 2025-09-04.
//

import SwiftUI

// MARK: - Loading Overlay View

struct LoadingOverlayView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
                
                Text("Please wait...")
                    .font(.body)
                    .foregroundColor(.white)
            }
            .padding(32)
            .background(Color.black.opacity(0.3))
            .cornerRadius(12)
        }
    }
}
