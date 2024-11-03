//
//  ContentView.swift
//  RandomJokeApp_SwiftUI
//
//  Created by Eren Elçi on 4.11.2024.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var jokeListViewModel: JokeListViewModel
    
    init() {
        self.jokeListViewModel = JokeListViewModel()
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(jokeListViewModel.jokeList, id: \.id) { joke in
                            VStack {
                                Text(joke.type)
                                    .font(.headline)
                                    .padding()
                                Text(joke.setup)
                                    .padding()
                                Text(joke.punchline)
                                    .padding()
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding()
                        }
                    }
                    .padding()
                }
                Button {
                    Task {
                        jokeListViewModel.jokeList.removeAll(keepingCapacity: true)
                        await jokeListViewModel.downloadJokesAsync(url: URL(string: "https://official-joke-api.appspot.com/random_joke")!)
                    }
                } label: {
                    Text("New Joke")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .navigationTitle("Random Joke App")
        }
        .task {
            await jokeListViewModel.downloadJokesAsync(url: URL(string: "https://official-joke-api.appspot.com/random_joke")!)
        }
    }
}

#Preview {
    MainView()
}

