//
//  Question.swift
//  lotrquiz
//
//  Created by José Ibáñez Bengoechea on 4/3/22.
//

import Foundation

struct Question : Codable, Identifiable, Equatable {
    var id : Int
    var question : String
    var options : [String]
    var correctAnswer : String
}
