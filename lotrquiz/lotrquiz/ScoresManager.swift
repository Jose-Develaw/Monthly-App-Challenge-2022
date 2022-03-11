//
//  ScoresManager.swift
//  lotrquiz
//
//  Created by José Ibáñez Bengoechea on 11/3/22.
//

import Foundation

class ScoreManager {
    
    static func getTopScores() -> TopScores {
        
        guard let stringifyTopScores = UserDefaults.standard.data(forKey: "topScores") else {
            return TopScores(scores: [])
        }
        let decoder = JSONDecoder()
        
        guard let decoded = try? decoder.decode(TopScores.self, from: stringifyTopScores) else {
            fatalError("Failed to decode data from UserDefaults")
        }
        
        return decoded
        
    }
    
    static func saveTopScores(_ topScores: TopScores) {
        
        let encoder = JSONEncoder()
        
        guard let encoded = try? encoder.encode(topScores) else {
            fatalError("Failed to decode data from UserDefaults")
        }
        
        UserDefaults.standard.set(encoded, forKey: "topScores")
        
    }
    
}
