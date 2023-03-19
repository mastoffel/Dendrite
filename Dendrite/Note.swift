//
//  Note.swift
//  Dendrite
//
//  Created by Martin Stoffel on 19/03/2023.
//

import Foundation

struct Note: Identifiable {
    let id: UUID
    var title: String
    var body: String
    
    init(id: UUID = UUID(), title: String = "", body: String = "") {
        self.id = id
        self.title = title
        self.body = body
    }
}
