//
//  GameView.swift
//  TriviaApp
//
//  Created by Abhijeet Cherungottil on 10/23/25.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var vm: TriviaViewModel
    @Binding var showGame: Bool
    @State private var showScoreAlert = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header with timer and controls
                HStack {
                    if vm.totalTime > 0 {
                        Text("Time: \(vm.timeRemaining)s")
                            .font(.title3)
                            .bold()
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Button("Submit") {
                        vm.submit()
                        showScoreAlert = true
                    }
                    .disabled(vm.hasSubmitted)
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                .background(Color.blue)
                
                Divider()
                
                // Questions display
                if vm.questions.isEmpty {
                    Spacer()
                    VStack {
                        if vm.isLoading {
                            ProgressView()
                            Text("Loading questions...")
                                .foregroundStyle(.secondary)
                                .padding()
                        } else {
                            Text("No questions loaded")
                                .foregroundStyle(.secondary)
                        }
                    }
                    Spacer()
                } else {
                    if vm.useCardView {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(vm.questions) { q in
                                    QuestionCardView(question: q)
                                        .environmentObject(vm)
                                }
                            }.padding()
                        }
                    } else {
                        List {
                            ForEach(vm.questions) { q in
                                QuestionListRow(question: q)
                                    .environmentObject(vm)
                            }
                        }
                        .listStyle(.insetGrouped)
                    }
                }
            }
            .navigationTitle("Trivia Game")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(false)
            .toolbarBackground(Color.blue, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.light, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showGame = false
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .foregroundColor(.white)
                    }
                }
                if let err = vm.errorMessage {
                    ToolbarItem(placement: .bottomBar) {
                        Text(err).foregroundColor(.red).font(.caption)
                    }
                }
            }
            .alert("Score", isPresented: $showScoreAlert) {
                Button("OK", role: .cancel) {
                    showGame = false
                }
            } message: {
                Text("You scored \(vm.score) / \(vm.questions.count)")
            }
        }
    }
}
