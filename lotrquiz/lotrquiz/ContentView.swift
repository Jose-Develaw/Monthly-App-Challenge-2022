//
//  ContentView.swift
//  lotrquiz
//
//  Created by José Ibáñez Bengoechea on 4/3/22.
//

import SwiftUI
import Combine

enum GameState {
    case mainMenu, playing, finalScore, topScores
}

struct ContentView: View {
    
    var allQuestions : [Question] = Bundle.main.decode("questions.json")
    @State private var gameState : GameState = .mainMenu
    @State var gameStatus = GameStatus()
    @State private var topScores : TopScores = ScoreManager.getTopScores()
    
    //Timer
    @State var timer: Timer.TimerPublisher = Timer.publish(every: 1, on: .main, in: .common)
    @State var connectedTimer: Cancellable? = nil
    
    var body: some View {
        VStack{
            ZStack{
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                Color(.black)
                    .opacity(0.75)
                    .ignoresSafeArea()
                VStack{
                    Text("THE LORD OF THE QUIZ")
                        .font(.custom("Aniron", size: 26, relativeTo: .title))
                        .multilineTextAlignment(.center)
                        .padding()
                    Spacer()
                    if (gameState == .mainMenu){
                        MainMenuView(gameStatus: $gameStatus, gameState: $gameState, instantiateTimer: instantiateTimer)
                    }
                    if (gameState == .topScores){
                        TopScoresView(topScores: $topScores, gameState: $gameState)
                    }
                    if (gameState == .finalScore){
                        FinalScoreView(gameStatus: $gameStatus, topScores: $topScores, gameState: $gameState)
                    }
                    if (gameStatus.gameQuestions != [] && gameState == .playing){
                        PlayingView(gameStatus: $gameStatus, timer: $timer, cancelTimer: cancelTimer, instantiateTimer: instantiateTimer, gameState: $gameState)
                    }
                }                
                .padding(15)
                .frame(maxWidth: 550, maxHeight: 800)
            }
        }
        .preferredColorScheme(.dark)
        
    }
    
    func instantiateTimer() {
            self.timer = Timer.publish(every: 1, on: .main, in: .common)
            self.connectedTimer = self.timer.connect()
            return
    }
        
    func cancelTimer() {
        self.connectedTimer?.cancel()
        return
    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
