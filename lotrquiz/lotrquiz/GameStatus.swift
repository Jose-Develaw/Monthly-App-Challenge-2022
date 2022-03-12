//
//  GameStatus.swift
//  lotrquiz
//
//  Created by José Ibáñez Bengoechea on 12/3/22.
//

import Foundation

class GameStatus : ObservableObject {
    @Published var gameQuestions = ArraySlice<Question>()
    @Published var currentRound = 0
    
    @Published var score = 0
    @Published var answered = false
    @Published var selectedOption = ""
    @Published var options = [String]()
    @Published var areButtonsDisabled = false
    
    //Timer and Score Graphics
    @Published var tickingAmount = 0.0
    @Published var remaining = 30
    @Published var showEye = false
    @Published var showCorrect = false
}
