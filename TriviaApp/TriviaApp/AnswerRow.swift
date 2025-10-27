//
//  AnswerRow.swift
//  TriviaApp
//
//  Created by Abhijeet Cherungottil on 10/23/25.
//

import SwiftUI

struct AnswerRow: View {
    let answerText: String
    let selected: Bool
    let disabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            guard !disabled else { return }
            action()
        }) {
            HStack {
                Text(answerText)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                if selected {
                    Image(systemName: "checkmark.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(selected ? Color.blue : Color.gray.opacity(0.3), lineWidth: selected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
    }
}
