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
    @Binding var showEye : Bool
    @Binding var showCorrect : Bool
    
    var body: some View {
        ZStack{
            if(!showEye){
                Text(showCorrect ? "+\(remaining)" : "\(remaining)")
                    .font(.custom("Aniron", size: showCorrect ? 38 : 32, relativeTo: .title))
                    .foregroundColor(showCorrect ? .green : .white)
                    .frame(maxWidth: 150, maxHeight: 150)
                    
            } else {
                Image("eye")
                    .resizable()
                    .scaledToFit()
                    .padding(35)
                    .frame(maxWidth: 155, maxHeight: 155)
                    .offset(x: -4, y: 4)
                    .transition(.asymmetric(insertion: .scale.combined(with: .opacity), removal: .opacity))
                    
                    
            }
            
            
            if(tickingAmount > 10.0){
                Image("ringrule")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 150, maxHeight: 150)
                    .colorMultiply(ringColor())
                    .mask{
                        Arc(startAngle: .degrees(0), tickingAmount: tickingAmount, clockwise: true)
                            .strokeBorder(.red, style: StrokeStyle(lineWidth: 55, lineCap: .butt, lineJoin: .round))
                            .frame(maxWidth: 150, maxHeight: 150)
                    }
            }
        }
    }
    
    func ringColor() -> Color {
        if(showEye){
            return .red
        }
        
        if(showCorrect){
            return .green
        }
        
        if(remaining > 20) {
            return .white
        } else if (remaining > 10) {
            return .orange
        }
        return .red
    }
}

