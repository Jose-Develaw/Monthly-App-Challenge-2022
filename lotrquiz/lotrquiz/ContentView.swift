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
    var options : [String] {
        gameQuestions[currentRound].options.shuffled()
    }
    let columns = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    var body: some View {
        NavigationView{
            if (gameQuestions != []){
                VStack{
                    Text(gameQuestions[currentRound].question)
                    LazyVGrid(columns: columns){
                        ForEach(options, id: \.self){option in
                            Button{
                                currentRound += 1
                            } label: {
                                Text(option)
                            }
                        }
                    }
                }
            }
            
        }
        .navigationTitle("El señor de los anillos quiz")
        .onAppear{
            gameQuestions = allQuestions.shuffled()[..<10]
        }
    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
