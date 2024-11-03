//
//  Joke.swift
//  RandomJokeApp_SwiftUI
//
//  Created by Eren Elçi on 4.11.2024.
//

import Foundation


struct Joke : Codable {
    let type: String
    let setup: String
    let punchline: String
    let id : Int
}
