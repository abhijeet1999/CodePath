//
//  CardView.swift
//  MemoryGame
//
//  Created by Abhijeet Cherungottil on 10/18/25.
//

import SwiftUI

struct CardView: View {
    let card: Card

    var body: some View {
        ZStack {
            if card.isMatched {
                Color.clear
            } else if card.isFaceUp {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .shadow(radius: 4)
                Text(card.content)
                    .font(.largeTitle)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue)
            }
        }
        .frame(width: 90, height: 110)
        .animation(.easeInOut, value: card.isFaceUp)
    }
}



