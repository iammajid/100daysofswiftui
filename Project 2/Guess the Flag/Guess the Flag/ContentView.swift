//
//  ContentView.swift
//  Guess the Flag
//
//  Created by Majid Achhoud on 03.11.23.
//

import SwiftUI

struct FlagImage: View {
    var flags: String
    var opacity: Double
    
    var body: some View {
        Image(flags)
            .clipShape(.rect)
            .cornerRadius(5)
            .shadow(radius: 5)
            .opacity(opacity)
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    
    @State private var animationAmounts = [0.0, 0.0, 0.0]
    @State private var opacities = [1.0, 1.0, 1.0]
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.gray, .blue], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.black)
                
                VStack(spacing: 30) {
                    VStack (spacing: 15){
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(flags: countries[number], opacity: opacities[number])
                                .rotation3DEffect(.degrees(animationAmounts[number]), axis: (x: 0, y: 1, z: 0))
                        }
                    }
                }
                .frame(maxWidth: 400, maxHeight: 500)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your new score is \(score)")
        }
        
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 10
            withAnimation {
                animationAmounts[number] += 360
            }
        } else {
            scoreTitle = "Wrong.. \n That's the flag of \(countries[number])"
            score -= 10
        }
        
        withAnimation {
            for i in 0..<opacities.count {
                opacities[i] = i == number ? 1.0 : 0.25
            }
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        animationAmounts = [0.0, 0.0, 0.0]
        opacities = [1.0, 1.0, 1.0]
    }
}

#Preview {
    ContentView()
}
