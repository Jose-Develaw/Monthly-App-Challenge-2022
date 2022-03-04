//
//  Question.swift
//  lotrquiz
//
//  Created by José Ibáñez Bengoechea on 4/3/22.
//

import Foundation

struct Question : Codable, Identifiable {
    var id : Int
    var question : String
    var options : [String]
    var correctAnswer : String
}
