//
//  TopScoresView.swift
//  lotrquiz
//
//  Created by José Ibáñez Bengoechea on 12/3/22.
//

import SwiftUI

struct TopScoresView: View {
    @Binding var topScores : TopScores
    @Binding var gameState : GameState
    var body: some View {
        VStack{
            VStack{
                Text("Listado de puntuaciones")
                    .font(.custom("Aniron", size: 18, relativeTo: .headline))
                ScrollView{
                    LazyVStack{
                        ForEach(topScores.sortedScores, id: \.self) { score in
                            HStack (alignment: .lastTextBaseline){
                                Text(score.userName)
                                    .font(.custom("Aniron", size: 16, relativeTo: .headline))
                                Spacer()
                                Text(score.score, format: .number)
                                    .font(.custom("Aniron", size: 16, relativeTo: .headline))
                            }
                        }
                    }
                }
                .padding()
                
                Button{
                    withAnimation{
                        gameState = .mainMenu
                    }
                } label: {
                    Text("Volver al menú")
                        .buttonLabel()
                }
            }
            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
            Spacer()
        }
    }
}

