//
//  RingTimer.swift
//  lotrquiz
//
//  Created by José Ibáñez Bengoechea on 10/3/22.
//

import SwiftUI

struct RingTimer: View {
    @Binding var tickingAmount : Double
    @Binding var remaining : Int
    
    var body: some View {
        ZStack{
            Text(remaining, format: .number)
                .font(.custom("Aniron", size: 32, relativeTo: .title))
                .frame(maxWidth: 150, maxHeight: 150)
            if(tickingAmount > 10.0){
                Image("ringrule")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 150, maxHeight: 150)
                    .colorMultiply(ringColor())
                    .mask{
                        Arc(startAngle: .degrees(0), tickingAmount: tickingAmount, clockwise: true)
                            .strokeBorder(.red, style: StrokeStyle(lineWidth: 35, lineCap: .round, lineJoin: .round))
                            .frame(maxWidth: 150, maxHeight: 150)
                    }
            }
        }
    }
    
    func ringColor() -> Color {
        if(remaining > 20) {
            return .white
        } else if (remaining > 10) {
            return .orange
        }
        return .red
    }
}

