//
//  QuestionCardView.swift
//  TriviaApp
//
//  Created by Abhijeet Cherungottil on 10/23/25.
//

import SwiftUI

struct QuestionCardView: View {
    let question: TriviaQuestion
    @EnvironmentObject var vm: TriviaViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(question.decodedQuestion())
                .font(.headline)
                .multilineTextAlignment(.leading)
            VStack(spacing: 8) {
                ForEach(answerList(), id: \.self) { ans in
                    let isSelected = vm.selections[question.id] == ans
                    let isCorrect = ans == question.decodedCorrect()
                    let isSubmitted = vm.hasSubmitted
                    
                    AnswerRow(answerText: ans, selected: isSelected, disabled: isSubmitted) {
                        Task { @MainActor in
                            vm.selectAnswer(question: question, answer: ans)
                        }
                    }
                    .overlay(
                        Group {
                            if isSubmitted {
                                if isCorrect {
                                    RoundedRectangle(cornerRadius: 8).stroke(Color.green, lineWidth: 2)
                                } else if isSelected && !isCorrect {
                                    RoundedRectangle(cornerRadius: 8).stroke(Color.red, lineWidth: 2)
                                }
                            }
                        }
                    )
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 14).fill(.ultraThinMaterial))
        .shadow(radius: 3)
    }
    
    private func answerList() -> [String] {
        if question.type == "boolean" {
            return ["True", "False"]
        } else {
            return question.shuffledAnswers().map { $0.htmlDecoded() }
        }
    }
}
