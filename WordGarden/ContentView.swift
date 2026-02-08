//
//  ContentView.swift
//  WordGarden
//
//  Created by Zimeng Yang on 2/5/26.
//

import SwiftUI

struct ContentView: View {
    @State private var wordsGuessed = 0
    @State private var wordsMissed = 0
    @State private var wordsToGuess = ["SWIFT", "DOG", "CAT"]
    @State private var wordsInGame = 0
    @State private var gameStatusMessage = "How Many Gueses to Uncover the Hidden Word?"
    @State private var currentWord = 0
    @State private var guessLetter = ""
    @State private var imageName = "flower8"
    @State private var playAgainHidden = true
    @FocusState private var textFieldIsFocused: Bool
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Words Guessed: \(wordsGuessed)")
                    Text("Words Missed: \(wordsMissed)")
                }
                Spacer()
                VStack(alignment: .trailing ) {
                    Text("Words to Guessed: \(wordsToGuess.count - (wordsMissed + wordsGuessed))")
                    Text("Words in Game : \(wordsToGuess.count)")
                }
            }
            .padding(.horizontal)
            Spacer()
            
            Text(gameStatusMessage)
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()
            
            //TODO: Switch to wordsToGuess[currentWord]
            
            Text("_ _ _ _ _")
                .font(.title)
            
            if playAgainHidden {
                HStack {
                    TextField("", text: $guessLetter)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 30)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 2)
                        }
                        .keyboardType(.asciiCapable)
                        .submitLabel(.done)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.characters)
                        .onChange(of: guessLetter) {
                            guessLetter = guessLetter.trimmingCharacters(in: .letters.inverted)
                            guard let lastCar = guessLetter.last else {
                                return
                            }
                            guessLetter = String(lastCar).uppercased()
                        }
                        .focused($textFieldIsFocused)
                    
                    Button("Guess a Letter:") {
                        //TODO: Guess a letter button
                        playAgainHidden = false
                        textFieldIsFocused = false
                    }
                    .buttonStyle(.bordered)
                    .tint(.mint)
                    .disabled(guessLetter.isEmpty)
                }
            } else {
                Button("Another Word? ") {
                    //TODO: button action
                    playAgainHidden = true
                }
                .buttonStyle(.borderedProminent)
                .tint(.mint)
            }
            
              
            Image(imageName)
                .resizable()
                .scaledToFit()
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    ContentView()
}
