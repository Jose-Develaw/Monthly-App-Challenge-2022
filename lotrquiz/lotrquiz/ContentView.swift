//
//  ContentView.swift
//  lotrquiz
//
//  Created by José Ibáñez Bengoechea on 4/3/22.
//

import SwiftUI

struct ContentView: View {
    var allQuestions : [Question] = Bundle.main.decode("questions.json")
    @State private var gameQuestions = ArraySlice<Question>()
    @State private var currentRound = 0
    @State private var score = 0
    @State private var answered = false
    @State private var selectedOption = ""
    @State private var options = [String]()
        
   
    
    
    var body: some View {
        NavigationView{
            if (gameQuestions != []){
                VStack{
                    VStack(alignment: .center){
                        Text(gameQuestions[currentRound].question)
                            .font(.headline)
                    }
                    .padding()
                    ForEach(options, id: \.self){option in
                        Button{
                            answerQuestion(option)
                            
                        } label: {
                            Text(option)
                                .frame(maxWidth: .infinity, maxHeight: 40)
                                .background(resolveColor(option))
                                .foregroundColor(.white)
                                .padding(.horizontal)
                        }
                    }
                }
                .navigationTitle("El señor de los anillos")
                .frame(maxWidth: 550)
            }
           
        }
        .onAppear{
            gameQuestions = allQuestions.shuffled()[..<10]
            options = gameQuestions[currentRound].options.shuffled()
        }
    }
    
    func answerQuestion(_ option: String) {
        withAnimation{
            selectedOption = option
            answered = true
        }
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
            currentRound += 1
            selectedOption = ""
            answered = false
            options = gameQuestions[currentRound].options.shuffled()
        }
        
    }
    
    func resolveColor(_ option: String) -> Color {
        if(!answered){
            return .blue
        }
        if(option == gameQuestions[currentRound].correctAnswer){
            return .green
        } else if (option != gameQuestions[currentRound].correctAnswer && option == selectedOption){
            return .red
        }
        return .blue
    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
