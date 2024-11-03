//
//  Webservice.swift
//  RandomJokeApp_SwiftUI
//
//  Created by Eren Elçi on 4.11.2024.
//

import Foundation


class Webservice {
    
    
    func downloadJoke(url: URL) async throws -> Joke {
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do{
            let joke = try JSONDecoder().decode(Joke.self, from: data)
            return joke
        } catch {
            print("Error decoding Joke: \(error)")
            throw error
        }
    }
    
    
    
}
