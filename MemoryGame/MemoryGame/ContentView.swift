import SwiftUI



struct ContentView: View {
    @State private var cards: [Card] = []
    @State private var indexOfFirstFlippedCard: Int? = nil
    @State private var numberOfPairs = 3
    @State private var showSizePicker = false
    @State private var showWinAlert = false

    var body: some View {
        VStack {
            // MARK: - Top Buttons
            HStack {
                Button(action: {
                    showSizePicker = true
                }) {
                    Text("Choose Size")
                        .fontWeight(.semibold)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Spacer()

                Button(action: {
                    resetGame()
                }) {
                    Text("Reset Game")
                        .fontWeight(.semibold)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)
            .padding(.top)

            // MARK: - Game Grid
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                    ForEach(cards) { card in
                        CardView(card: card)
                            .onTapGesture {
                                flipCard(card)
                            }
                    }
                }
                .padding()
            }
        }
        .onAppear {
            resetGame()
        }
        .confirmationDialog("Select Game Size", isPresented: $showSizePicker) {
            Button("3 Pairs") { numberOfPairs = 3; resetGame() }
            Button("6 Pairs") { numberOfPairs = 6; resetGame() }
            Button("10 Pairs") { numberOfPairs = 10; resetGame() }
            Button("Cancel", role: .cancel) {}
        }
        .alert("🎉 You Won!", isPresented: $showWinAlert) {
            Button("Play Again") {
                resetGame()
            }
        } message: {
            Text("All pairs matched successfully.")
        }
        .background(
            LinearGradient(colors: [.blue.opacity(0.1), .purple.opacity(0.2)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
        )
    }

    // MARK: - Game Logic

    func flipCard(_ card: Card) {
        guard let index = cards.firstIndex(where: { $0.id == card.id }) else { return }
        if cards[index].isMatched || cards[index].isFaceUp { return }

        cards[index].isFaceUp.toggle()

        if let firstIndex = indexOfFirstFlippedCard {
            if cards[firstIndex].content == cards[index].content {
                cards[firstIndex].isMatched = true
                cards[index].isMatched = true

                // Check if all cards matched
                if cards.allSatisfy({ $0.isMatched }) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showWinAlert = true
                    }
                }

            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    cards[firstIndex].isFaceUp = false
                    cards[index].isFaceUp = false
                }
            }
            indexOfFirstFlippedCard = nil
        } else {
            indexOfFirstFlippedCard = index
        }
    }

    func resetGame() {
        let allEmojis = ["🐶","🐱","🐭","🐹","🐰","🦊","🐻","🐼","🐨","🐯","🐸","🐵","🦁","🐮","🐷"]
        let chosenEmojis = Array(allEmojis.shuffled().prefix(numberOfPairs))
        cards = (chosenEmojis + chosenEmojis)
            .shuffled()
            .map { Card(content: $0) }
        indexOfFirstFlippedCard = nil
    }
}

#Preview {
    ContentView()
}
