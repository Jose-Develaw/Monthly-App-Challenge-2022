//
//  AnswerButton.swift
//  lotrquiz
//
//  Created by José Ibáñez Bengoechea on 10/3/22.
//

import SwiftUI

struct AnswerButton: View {
    var resolvedColor : Color
    var option : String
    
    var body: some View {
        Text(option)
            .frame(maxWidth: .infinity, maxHeight: 50)
            .foregroundColor(.white)
            .font(.custom("Aniron", size: 18, relativeTo: .headline))
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .strokeBorder(resolvedColor, lineWidth: 2)
            )
            .padding(.horizontal)
    }
}
