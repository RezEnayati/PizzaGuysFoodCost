//
//  Gradient.swift
//  PizzaGuysFoodCost
//
//  Created by Reza Enayati on 10/23/24.
//
import SwiftUI
import Foundation

extension Color {
    static let pizzaGuysRed = Color(red: 206 / 255, green: 32 / 255, blue: 41 / 255)
}

extension LinearGradient {
    static let pizzaGuysGradient = LinearGradient(gradient: Gradient(colors: [Color.pizzaGuysRed, Color.black]), startPoint: .top, endPoint: .bottom)
}

extension View {
    var pizzaGuysBackGround: some View {
        self.background(
            VStack{
                LinearGradient.pizzaGuysGradient
                    .ignoresSafeArea()
                    .frame(height: 300)
                    .frame(maxWidth: .infinity)
                Color.black
            }
        
            
        )
    }
}
