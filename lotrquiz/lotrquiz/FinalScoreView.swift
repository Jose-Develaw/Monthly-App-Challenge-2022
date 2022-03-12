//
//  FinalScoreView.swift
//  lotrquiz
//
//  Created by José Ibáñez Bengoechea on 12/3/22.
//

import SwiftUI

struct FinalScoreView: View {
    
    @Binding var gameStatus : GameStatus
    @Binding var topScores : TopScores
    @State private var userName = ""
    @Binding var gameState : GameState
    
    var body: some View {
        VStack{
            VStack{
                Spacer()
                Text("Puntuación final: \(gameStatus.score)")
                    .font(.custom("Aniron", size: 18, relativeTo: .headline))
                TextField("Escribe tu nombre", text: $userName)
                    .multilineTextAlignment(.center)
                    .accentColor(Color(red: 168/255, green: 147/255, blue: 36/255, opacity: 0.6))
                    .padding(.horizontal)
                    .goldenFramed()
                Spacer()
                Button{
                    let newScore = Score(userName: userName, score: gameStatus.score)
                    topScores.scores.append(newScore)
                    ScoreManager.saveTopScores(topScores)
                    withAnimation{
                        gameState = .mainMenu
                    }
                } label: {
                    Text("Guardar puntuación")
                        .foregroundColor(userName.count <= 0 ? .gray : .white)
                        .goldenFramed()
                        
                }
                .disabled(userName.count <= 0)
                
                Button{
                    withAnimation{
                        gameState = .mainMenu
                    }
                } label: {
                    Text("Salir sin guardar")
                        .goldenFramed()
                }
                Spacer()
            }
            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
            Spacer()
        }
    }
}

