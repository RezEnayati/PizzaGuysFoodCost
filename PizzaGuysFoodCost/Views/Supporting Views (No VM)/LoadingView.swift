//
//  LoadingView.swift
//  PizzaGuysFoodCost
//
//  Created by Reza Enayati on 10/23/24.
//

import SwiftUI

struct LoadingView: View {
    
    @State private var scaleAmount: CGFloat = 1
    
    var body: some View {
        ZStack {
            Image(.pgLogo2)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaleEffect(scaleAmount)
                .frame(height: 40)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                scaleAmount = 1.5
            }
        }
    }
}

#Preview {
    LoadingView()
}
