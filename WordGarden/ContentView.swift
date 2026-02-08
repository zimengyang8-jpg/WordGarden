//
//  ContentView.swift
//  WordGarden
//
//  Created by Zimeng Yang on 2/5/26.
//

import SwiftUI
import AVFAudio

struct ContentView: View {
    
    private static let maxGuesses = 8

    @State private var wordsGuessed = 0
    @State private var wordsMissed = 0
    @State private var wordsInGame = 0
    @State private var gameStatusMessage = "How Many Gueses to Uncover the Hidden Word?"
    @State private var currentWordIndex = 0
    @State private var wordToGuess = ""
    @State private var revealedWord = ""
    @State private var lettersGuessed = ""
    @State private var guessesRemaining = maxGuesses
    @State private var guessLetter = ""
    @State private var imageName = "flower8"
    @State private var playAgainHidden = true
    @State private var  playAgainButtonLabel = "Another Word?"
    @State private var audioPlayer: AVAudioPlayer!

    @FocusState private var textFieldIsFocused: Bool

    private let wordsToGuess = ["SWIFT", "DOG", "CAT"]

    
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
                .frame(height: 80)
                .minimumScaleFactor(0.5) // shrink the text when it doesn't fit into the frame
                .padding()
            
            //TODO: Switch to wordsToGuess[currentWordIndex]
            
            Text(revealedWord)
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
                        .onSubmit {
                            guard guessLetter != "" else {
                                return
                            }
                            guessALetter()
                            updateGamePlay()
                        }
                    
                    Button("Guess a Letter:") {
                        guessALetter()
                        updateGamePlay()
                    }
                    .buttonStyle(.bordered)
                    .tint(.mint)
                    .disabled(guessLetter.isEmpty)
                }
            } else {
                Button(playAgainButtonLabel) {
                    // If all the words have been guessed
                    if currentWordIndex == wordsToGuess.count {
                        currentWordIndex = 0
                        wordsGuessed = 0
                        wordsMissed = 0
                        playAgainButtonLabel = "Another Word?"
                    }
                    
                    // Reset after word was guessed or missed
                    wordToGuess = wordsToGuess[currentWordIndex]
                    revealedWord = "_" + String(repeating: " _", count: wordToGuess.count-1)
                    lettersGuessed = ""
                    guessesRemaining = Self.maxGuesses
                    imageName = "flower\(guessesRemaining)"
                    gameStatusMessage = "How Many Gueses to Uncover the Hidden Word?"
                    playAgainHidden = true
                }
                .buttonStyle(.borderedProminent)
                .tint(.mint)
            }
            
              
            Image(imageName)
                .resizable()
                .scaledToFit()
                .animation(.easeIn(duration: 0.75), value: imageName)
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            wordToGuess = wordsToGuess[currentWordIndex]
            revealedWord = "_" + String(repeating: " _", count: wordToGuess.count-1)
        }
    }
    
    func guessALetter () {
        textFieldIsFocused = false
        lettersGuessed = lettersGuessed + guessLetter
        revealedWord = wordToGuess.map { letter in
                lettersGuessed.contains(letter) ? "\(letter)" : "_"
        }.joined(separator: " ")
        
    }
    
    func updateGamePlay() {
        if !wordToGuess.contains(guessLetter) { // does not contain
            guessesRemaining -= 1
            // Animate crumbling leaf and play incorrect sound
            imageName = "wilt\(guessesRemaining)"
            playSound(soundName: "incorrect")
            // Delay change to flower image until after wilt animation is done
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                imageName = "flower\(guessesRemaining)"
            }
        } else {
            playSound(soundName: "correct")
        }
        
        // When do we play another word?
         if !revealedWord.contains("_") { // Guessed when no "_" in revealedWord
             gameStatusMessage = "You Guessed It! It Took You \(lettersGuessed.count) Guesses to Guess the Word."
             wordsGuessed += 1
             currentWordIndex += 1
             playAgainHidden = false
             playSound(soundName: "word-guessed")
         } else if guessesRemaining == 0 {
             gameStatusMessage = "So Sorry, You Are Out of Guesses. The Word Was: \(wordToGuess)"
             wordsMissed += 1
             currentWordIndex += 1
             playAgainHidden = false
             playSound(soundName: "word-not-guessed")
         } else { // Keep Guessing
             //TODO: Redo this with LocalizedStringKey & Inflect
             gameStatusMessage = "You've Made \(lettersGuessed.count) Guess\(lettersGuessed.count == 1 ? "" : "es")"
         }
        
        if currentWordIndex == wordsToGuess.count {
            playAgainButtonLabel = "Restart Game?"
            gameStatusMessage = gameStatusMessage + "\nYou've Tried All the Words. Restart from the Beginning?"
        }
        
        guessLetter = ""
    }
    
    func playSound(soundName: String) {
        if audioPlayer != nil && audioPlayer.isPlaying{
            audioPlayer.stop()
        }
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("😡 Could not read file named \(soundName)")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print("😡 Error: \(error.localizedDescription) creating audioPlayer")
        }
    }
}

#Preview {
    ContentView()
}
