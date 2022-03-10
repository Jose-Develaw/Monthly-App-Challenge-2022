//
//  UIExtensions.swift
//  lotrquiz
//
//  Created by José Ibáñez Bengoechea on 10/3/22.
//

import Foundation
import SwiftUI

 struct ButtonStyleModifier : ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: 50)
            .foregroundColor(.white)
            .font(.custom("Aniron", size: 18, relativeTo: .headline))
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .strokeBorder(Color(red: 168/255, green: 147/255, blue: 36/255, opacity: 0.6), lineWidth: 2)
            )
            .padding(.horizontal)
    }
}

extension View {
    func buttonLabel() -> some View {
        modifier(ButtonStyleModifier())
    }
}


