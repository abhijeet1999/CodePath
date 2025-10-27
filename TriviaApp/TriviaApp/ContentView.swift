//
//  ContentView.swift
//  TriviaApp
//
//  Created by Abhijeet Cherungottil on 10/23/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vm = TriviaViewModel()
    @State private var showGame = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                ZStack(alignment: .center) {
                    Rectangle()
                        .fill(Color.blue)
                        .frame(height: 100)
                        .ignoresSafeArea(edges: .top)
                    
                    Text("Trivia Game")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 60)
                }
                .background(Color.blue)
                
                // Content
                ScrollView {
                    VStack(spacing: 20) {
                        OptionsView()
                            .environmentObject(vm)
                            .padding(.horizontal)
                            .padding(.top)
                        
                        if vm.isLoading {
                            ProgressView()
                                .padding()
                        }
                    }
                    .padding(.bottom, 100)
                }
                
                // Start Button
                VStack(spacing: 0) {
                    
                    Button(action: {
                        Task {
                            await vm.loadQuestions()
                            showGame = true
                        }
                    }) {
                        Text("Start Trivia")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.green)
                            .cornerRadius(12)
                    }
                    .disabled(vm.isLoading)
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                }
            }
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $showGame) {
                GameView(showGame: $showGame)
                    .environmentObject(vm)
            }
        }
    }
}

#Preview {
    ContentView()
}
