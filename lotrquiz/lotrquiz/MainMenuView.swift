//
//  MainMenuView.swift
//  lotrquiz
//
//  Created by José Ibáñez Bengoechea on 12/3/22.
//

import SwiftUI

struct MainMenuView: View {
    var allQuestions : [Question] = Bundle.main.decode("questions.json")
    @Binding var gameStatus : GameStatus
    @Binding var gameState : GameState
    var instantiateTimer: () -> Void
    
    var body: some View {
        VStack{
            Spacer()
            VStack{
                Button{
                    withAnimation{
                       initGame()
                    }
                } label: {
                    Text("Iniciar partida")
                        .buttonLabel()
                }
                Button{
                    withAnimation{
                        gameState = .topScores
                    }
                } label: {
                    Text("Ver puntuaciones")
                        .buttonLabel()
                }
            }
            .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)))
            Spacer()
        }
    }
    
    func initGame(){
        gameStatus.answered = false
        gameStatus.areButtonsDisabled = false
        gameStatus.tickingAmount = 0.0
        gameStatus.remaining = 30
        gameStatus.currentRound = 0
        gameStatus.score = 0
        gameStatus.showCorrect = false
        gameStatus.showEye = false
        gameStatus.gameQuestions = allQuestions.shuffled()[..<10]
        gameStatus.options = gameStatus.gameQuestions[gameStatus.currentRound].options.shuffled()
        instantiateTimer()
        gameState = .playing
    }
}
