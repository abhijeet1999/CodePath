//
//  Card.swift
//  MemoryGame
//
//  Created by Abhijeet Cherungottil on 10/18/25.
//

import Foundation

struct Card: Identifiable {
    let id = UUID()
    let content: String
    var isFaceUp = false
    var isMatched = false
}
