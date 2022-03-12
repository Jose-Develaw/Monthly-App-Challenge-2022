//
//  PlayingView.swift
//  lotrquiz
//
//  Created by José Ibáñez Bengoechea on 12/3/22.
//

import SwiftUI
import Combine

struct PlayingView: View {
    
    @ObservedObject var gameStatus : GameStatus
    @Binding var timer : Timer.TimerPublisher
    var cancelTimer : () -> Void
    var instantiateTimer : () -> Void
    @Binding var gameState : GameState
    
    var body: some View {
        VStack{
            Spacer()
            RingTimer(tickingAmount: $gameStatus.tickingAmount, remaining: $gameStatus.remaining, showEye: $gameStatus.showEye, showCorrect: $gameStatus.showCorrect)
            Spacer()
            VStack{
                Spacer()
                VStack(alignment: .center){
                    Text(gameStatus.gameQuestions[gameStatus.currentRound].question)
                        .font(.custom("Aniron", size: 16, relativeTo: .headline))
                        .multilineTextAlignment(.center)
                }
                .padding()
                ForEach(gameStatus.options, id: \.self){option in
                    Button{
                        gameStatus.areButtonsDisabled = true
                        Task.init(priority: .high) {
                            cancelTimer()
                            await answerQuestion(option)
                        }
                    } label: {
                        AnswerButton(resolvedColor: resolveColor(option), option: option)
                    }
                    .disabled(gameStatus.areButtonsDisabled)
                }
                
            }
            .frame(maxHeight: .infinity)
            Text("Puntuación: \(gameStatus.score)")
                .font(.custom("Aniron", size: 18, relativeTo: .headline))
                .padding()
            
        }
        .onReceive(timer){ _ in
            if (gameStatus.remaining > 0 && !gameStatus.answered) {
                withAnimation(.linear(duration: 1)){
                    gameStatus.tickingAmount += 12
                }
                gameStatus.remaining -= 1
            } else {
                cancelTimer()
                withAnimation{
                    gameStatus.showEye = true
                }
                gameStatus.areButtonsDisabled = true
                Task.init(priority: .high) {
                    await answerQuestion("")
                }
            }
            
        }
        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
    }
    
    func nextRound(){
        gameStatus.remaining = 30
        gameStatus.currentRound += 1
        gameStatus.selectedOption = ""
        gameStatus.answered = false
        gameStatus.options = gameStatus.gameQuestions[gameStatus.currentRound].options.shuffled()
        gameStatus.tickingAmount = 0.0
        instantiateTimer()
        gameStatus.areButtonsDisabled = false
        gameStatus.showCorrect = false
        withAnimation{
            gameStatus.showEye = false
        }
    }
    
    
    
    
    func answerQuestion(_ option: String) async {
        withAnimation{
            gameStatus.selectedOption = option
            gameStatus.answered = true
        }
        if(option ==  gameStatus.gameQuestions[ gameStatus.currentRound].correctAnswer){
            gameStatus.showCorrect = true
            gameStatus.score +=  gameStatus.remaining
        } else {
            withAnimation{
                gameStatus.showEye = true
            }
        }
        
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        if(gameStatus.currentRound < 9){
            nextRound()
                
        } else {
            gameState = .finalScore
        }
    }
    
    
    
    func resolveColor(_ option: String) -> Color {
        if(!gameStatus.answered){
            return Color(red: 168/255, green: 147/255, blue: 36/255, opacity: 0.6)
        }
        if(option == gameStatus.gameQuestions[gameStatus.currentRound].correctAnswer){
            return .green
        } else if (option != gameStatus.gameQuestions[gameStatus.currentRound].correctAnswer && option == gameStatus.selectedOption){
            return .red
        }
        return Color(red: 168/255, green: 147/255, blue: 36/255, opacity: 0.6)
    }
}
