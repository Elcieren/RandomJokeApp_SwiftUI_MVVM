//
//  JokeViewModel.swift
//  RandomJokeApp_SwiftUI
//
//  Created by Eren Elçi on 4.11.2024.
//

import Foundation

@MainActor
class JokeListViewModel : ObservableObject {
    
    @Published var jokeList = [JokeViewModel]()
    let webservice = Webservice()
   
    
    func downloadJokesAsync(url: URL) async {
        do {
            let Joke = try await webservice.downloadJoke(url: url)
            self.jokeList.append(JokeViewModel(joke: Joke))
            
        } catch {
            
        }
    }
    
}




struct JokeViewModel {
    let joke: Joke
    
    var id: Int {
        joke.id
    }
    
    var punchline: String {
        joke.punchline
    }
    
    var setup: String {
        joke.setup
    }
    
    var type: String {
        joke.type
    }
}
