//
//  DendriteApp.swift
//  Dendrite
//
//  Created by Martin Stoffel on 19/03/2023.
//

import SwiftUI

@main
struct DendriteApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(notes: loadNotes())
        }
    }
}

func loadNotes() -> [Note] {
    if let data = UserDefaults.standard.data(forKey: "notes") {
        do {
            let decoder = JSONDecoder()
            let notes = try decoder.decode([Note].self, from: data)
            return notes
        } catch {
            print("Error decoding notes: \(error)")
        }
    }
    return []
}



