//
//  GameStatus.swift
//  lotrquiz
//
//  Created by José Ibáñez Bengoechea on 12/3/22.
//

import Foundation

struct GameStatus {
    var gameQuestions = ArraySlice<Question>()
    var currentRound = 0
    
    var score = 0
    var answered = false
    var selectedOption = ""
    var options = [String]()
    var areButtonsDisabled = false
    
    //Timer and Score Graphics
    var tickingAmount = 0.0
    var remaining = 30
    var showEye = false
    var showCorrect = false
}
