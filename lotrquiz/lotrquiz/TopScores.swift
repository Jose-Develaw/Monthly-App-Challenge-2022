//
//  TopScores.swift
//  lotrquiz
//
//  Created by José Ibáñez Bengoechea on 11/3/22.
//

import Foundation

struct Score : Codable, Hashable{
    var userName : String
    var score : Int
}

struct TopScores : Codable {
    var scores : [Score]
    
    var sortedScores: [Score] {
        scores.sorted{$0.score > $1.score}
    }
}
