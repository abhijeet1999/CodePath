//
//  QuestionListRow.swift
//  TriviaApp
//
//  Created by Abhijeet Cherungottil on 10/23/25.
//

import SwiftUI

struct QuestionListRow: View {
    let question: TriviaQuestion
    @EnvironmentObject var vm: TriviaViewModel
    @State private var expanded = false
    
    var body: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(question.decodedQuestion())
                        .font(.subheadline)
                    Spacer()
                    Image(systemName: expanded ? "chevron.up" : "chevron.down")
                        .onTapGesture { expanded.toggle() }
                }
                if expanded {
                    ForEach(answerList(), id: \.self) { ans in
                        let isSelected = vm.selections[question.id] == ans
                        let isCorrect = ans == question.decodedCorrect()
                        let isSubmitted = vm.hasSubmitted
                        
                        AnswerRow(answerText: ans, selected: isSelected, disabled: isSubmitted) {
                            Task { @MainActor in
                                vm.selectAnswer(question: question, answer: ans)
                            }
                        }
                        .background(
                            Group {
                                if isSubmitted {
                                    if isCorrect {
                                        Color.green.opacity(0.15)
                                    } else if isSelected && !isCorrect {
                                        Color.red.opacity(0.15)
                                    } else {
                                        Color.clear
                                    }
                                }
                            }
                        )
                    }
                }
            }
            .padding(.vertical, 6)
        }
    }
    
    private func answerList() -> [String] {
        if question.type == "boolean" {
            return ["True","False"]
        } else {
            return question.shuffledAnswers().map { $0.htmlDecoded() }
        }
    }
}
