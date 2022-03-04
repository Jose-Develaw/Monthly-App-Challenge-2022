//
//  Bundle-Decode.swift
//  lotrquiz
//
//  Created by José Ibáñez Bengoechea on 4/3/22.
//

import Foundation

extension Bundle {
    func decode<T: Codable>(_ file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in the bundle")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from the bundle")
        }
        
        let decoder = JSONDecoder()
        
        guard let decoded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode data from \(file)")
        }

        return decoded
    }
}
