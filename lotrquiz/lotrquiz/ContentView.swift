//
//  ContentView.swift
//  lotrquiz
//
//  Created by José Ibáñez Bengoechea on 4/3/22.
//

import SwiftUI

struct ContentView: View {
    var questions : [Question] = Bundle.main.decode("questions.json")
    
    var body: some View {
        NavigationView{
            List{
                ForEach(questions){ question in
                    Text(question.question)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
