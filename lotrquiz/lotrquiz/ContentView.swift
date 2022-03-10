//
//  ContentView.swift
//  lotrquiz
//
//  Created by José Ibáñez Bengoechea on 4/3/22.
//

import SwiftUI
import Combine

struct ContentView: View {
    var allQuestions : [Question] = Bundle.main.decode("questions.json")
    @State private var gameQuestions = ArraySlice<Question>()
    @State private var currentRound = 0
    @State private var score = 0
    @State private var answered = false
    @State private var selectedOption = ""
    @State private var options = [String]()
    @State private var areButtonsDisabled = false
        
    @State private var tickingAmount = 0.0
    @State private var remaining = 30
    
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
                if (gameQuestions != []){
                    VStack{
                        Text("THE LORD OF THE QUIZ")
                            .font(.custom("Aniron", size: 28, relativeTo: .title))
                            .multilineTextAlignment(.center)
                            .padding()
                        Spacer()
                        RingTimer(tickingAmount: $tickingAmount, remaining: $remaining)
                        Spacer()
                        VStack{
                            Spacer()
                            VStack(alignment: .center){
                                Text(gameQuestions[currentRound].question)
                                    .font(.custom("Aniron", size: 18, relativeTo: .headline))
                                    .multilineTextAlignment(.center)
                            }
                            .padding()
                            ForEach(options, id: \.self){option in
                                Button{
                                    areButtonsDisabled = true
                                    Task.init(priority: .high) {
                                        cancelTimer()
                                        await answerQuestion(option)
                                    }
                                } label: {
                                    AnswerButton(resolvedColor: resolveColor(option), option: option)
                                }
                                .disabled(areButtonsDisabled)
                            }
                        }
                        .frame(maxHeight: .infinity)
                        Text("Puntuación: \(score)")
                            .font(.custom("Aniron", size: 18, relativeTo: .headline))
                            .padding()
                        
                    }
                    .padding(15)
                    .preferredColorScheme(.dark)
                    .onReceive(timer){ _ in
                        
                        if (remaining > 0 && !answered) {
                            withAnimation(.linear(duration: 1)){
                                tickingAmount += 12
                            }
                            remaining -= 1
                        } else {
                            cancelTimer()
                            areButtonsDisabled = true
                            Task.init(priority: .high) {
                                await answerQuestion("")
                            }
                        }
                        
                    }
                    .frame(maxWidth: 550, maxHeight: 800)
                }
            }
        }
        .onAppear{
            gameQuestions = allQuestions.shuffled()[..<10]
            options = gameQuestions[currentRound].options.shuffled()
            instantiateTimer()
        }
        
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
    
    func nextRound(){
        remaining = 30
        currentRound += 1
        selectedOption = ""
        answered = false
        options = gameQuestions[currentRound].options.shuffled()
        tickingAmount = 0.0
        instantiateTimer()
        areButtonsDisabled = false
    }
    
    func resetGame(){
        gameQuestions = allQuestions.shuffled()[..<10]
        currentRound = 0
        score = 0
        nextRound()
    }
    
    func answerQuestion(_ option: String) async {
        withAnimation{
            selectedOption = option
            answered = true
            if(option == gameQuestions[currentRound].correctAnswer){
                score += remaining
            }
        }
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        if(currentRound < 9){
            nextRound()
        } else {
            resetGame()
        }
       
        
    }
    
    
    
    func resolveColor(_ option: String) -> Color {
        if(!answered){
            return Color(red: 168/255, green: 147/255, blue: 36/255, opacity: 0.6)
        }
        if(option == gameQuestions[currentRound].correctAnswer){
            return .green
        } else if (option != gameQuestions[currentRound].correctAnswer && option == selectedOption){
            return .red
        }
        return Color(red: 168/255, green: 147/255, blue: 36/255, opacity: 0.6)
    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
