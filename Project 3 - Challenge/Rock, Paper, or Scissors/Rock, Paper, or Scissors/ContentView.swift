//
//  ContentView.swift
//  Rock, Paper, or Scissors
//
//  Created by Majid Achhoud on 10.11.23.
//

import SwiftUI

struct ContentView: View {
    
    let moves = ["🪨", "📄", "✂️"]
    @State private var gameChoice = Int.random(in: 0..<3)
    @State private var shouldWin = Bool.random()
    @State private var score = 0
    @State private var round = 1
    @State private var gameEnded = false
    
    @State private var selectedMove: Int?
    @State private var feedbackColor: Color = .clear
    
    
    var body: some View {
        ZStack {
            Color(UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00))
                .ignoresSafeArea()
            
            VStack (spacing: 0) {
                Text("Rock, Paper, Scissors")
                    .font(.title.bold())
                    .foregroundStyle(.black)
                    .padding(10)
                
                Text("""
                Outsmart the app in Rock, Paper, Scissors!
                Each round, choose right to win or lose as
                prompted. Score points for correct choices.
                Game ends after 10 rounds.
                """)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.bottom, 70)
                
                
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 320, height: 170)
                        .background(.white)
                        .cornerRadius(8)
                        .shadow(color: .black.opacity(0.02), radius: 5.87746, x: 0.90423, y: 0.90423)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .inset(by: 0.45)
                                .stroke(Color(red: 0.77, green: 0.78, blue: 0.81).opacity(0.6), lineWidth: 0.9))
                    
                    VStack(alignment: .center) {
                        Text(moves[gameChoice])
                            .font(.system(size: 69))
                            .padding(5)
                        
                        Text(shouldWin ? "Win against this!" : "Lose against this!")
                            .font(.system(size: 16).weight(.medium))
                            .padding(5)
                    }
                }
                
                VStack {
                    Text("Tap the right answer")
                        .font(.system(size: 14))
                        .padding(.bottom, 10)

                    HStack(spacing: 20) {
                        ForEach(0..<3) { index in
                            Button(action: { self.answerTapped(move: index) }) {
                                Text(moves[index])
                                    .frame(width: 95, height: 95)
                                    .background(.white)
                                    .cornerRadius(8)
                                    .shadow(color: .black.opacity(0.02), radius: 5.87746, x: 0.90423, y: 0.90423)
                                    .font(.title)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(selectedMove == index ? feedbackColor : .clear, lineWidth: 1)
                                    )
                            }
                        }
                    }
                }
                .padding(60)

                
                HStack (spacing: 150) {
                    Text("Score: \(score)")
                        .font(.system(size: 20).weight(.bold))
                        .foregroundColor(Color(red: 0.59, green: 0.59, blue: 0.63))
                    
                    Text("Round: \(round)")
                        .font(.system(size: 20).weight(.bold))
                        .foregroundColor(Color(red: 0.59, green: 0.59, blue: 0.63))
                }
                .padding(.top, 80)
            }
            .padding()
        }
        .alert(isPresented: $gameEnded) {
                Alert(
                    title: Text("Game finished!"),
                    message: Text("Your score is \(score)."),
                    dismissButton: .default(Text("Start new game"), action: resetGame)
                )
        }
    }
    
    func answerTapped(move: Int) {
        let correctMove = shouldWin ? (gameChoice + 1) % 3 : (gameChoice + 2) % 3
        selectedMove = move

        if move == correctMove {
            feedbackColor = .green
            score += 1
        } else {
            feedbackColor = .red
            score -= 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.selectedMove = nil
            self.proceedToNextRound()
        }
    }


        func proceedToNextRound() {
            gameChoice = Int.random(in: 0..<3)
            shouldWin.toggle()

            round += 1
            if round > 10 {
                gameEnded = true
            }
        }
    
    func play(move: Int) {
        let correctMove = shouldWin ? (gameChoice + 1) % 3 : (gameChoice + 2) % 3

        if move == correctMove {
            score += 1
        } else {
            score -= 1
        }

        gameChoice = Int.random(in: 0..<3)
        shouldWin.toggle()

        round += 1
        if round > 10 {
            gameEnded = true
        }
    }

    
    func resetGame() {
        score = 0
        round = 1
        gameChoice = Int.random(in: 0..<3)
        shouldWin = Bool.random()
        gameEnded = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
