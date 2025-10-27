//
//  OptionsView.swift
//  TriviaApp
//
//  Created by Abhijeet Cherungottil on 10/23/25.
//

import SwiftUI

struct OptionsView: View {
    @EnvironmentObject var vm: TriviaViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Number of Questions
            VStack(alignment: .leading, spacing: 8) {
                Text("Number of Questions")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Stepper(value: $vm.numberOfQuestions, in: 1...50) {
                    Text("\(vm.numberOfQuestions)")
                        .font(.title3)
                        .bold()
                }
            }
            
            // Category
            HStack {
                Text("Select Category")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                Picker("", selection: $vm.selectedCategory) {
                    ForEach(TriviaCategory.allCases) { c in
                        Text(c.rawValue).tag(c)
                    }
                }
                .pickerStyle(.menu)
            }
            
            // Difficulty Slider
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Difficulty:")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(difficultyLabel)
                        .font(.subheadline)
                        .bold()
                }
                
                Slider(value: $vm.difficultyValue, in: 0...3, step: 1)
            }
            
            // Type
            HStack {
                Text("Select Type")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                Picker("", selection: $vm.selectedType) {
                    ForEach(TriviaType.allCases) { t in
                        Text(t.rawValue).tag(t)
                    }
                }
                .pickerStyle(.menu)
            }
            
            // Timer Duration
            HStack {
                Text("Timer Duration")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                Picker("", selection: $vm.selectedTimeDuration) {
                    ForEach(TimeDuration.allCases) { duration in
                        Text(duration.rawValue).tag(duration)
                    }
                }
                .pickerStyle(.menu)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }
    
    private var difficultyLabel: String {
        switch vm.selectedDifficulty {
        case .any: return "Any"
        case .easy: return "Easy"
        case .medium: return "Medium"
        case .hard: return "Hard"
        }
    }
}
