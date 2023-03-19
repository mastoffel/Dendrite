//
//  ContentView.swift
//  Dendrite
//
//  Created by Martin Stoffel on 19/03/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var notes = [Note]()
    @State private var selectedNote: Note?
    
    var body: some View {
        NavigationView {
            VStack {
                searchBar
                notesList
            }
            .frame(minWidth: 300)
            
            VStack {
                TextField("Title", text: Binding(get: { selectedNote?.title ?? "" }, set: { newTitle in
                    if let index = selectedNoteIndex {
                        selectedNote?.title = newTitle
                        notes[index].title = newTitle
                    }
                }))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                
                TextEditor(text: Binding(get: { selectedNote?.body ?? "" }, set: { newText in
                    if let index = selectedNoteIndex {
                        selectedNote?.body = newText
                        notes[index].body = newText
                    }
                }))
            }
        }
    }
    
    private var searchBar: some View {
        HStack {
            TextField("Search", text: .constant(""))
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: addNote) {
                Image(systemName: "plus")
            }
        }
        .padding()
    }
    
    private var notesList: some View {
        List(notes) { note in
            Button(action: { selectNote(note) }) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(note.title.isEmpty ? "Untitled" : note.title)
                            .font(.headline)
//                        Text(note.body)
//                            .font(.subheadline)
//                            .lineLimit(1)
                    }
                }
            }
        }
    }
    
    private func addNote() {
        let newNote = Note(title: "Untitled", body: "")
        notes.append(newNote)
        selectedNote = newNote
    }
    
    private func selectNote(_ note: Note) {
        selectedNote = note
    }
    
    private var selectedNoteIndex: Int? {
        selectedNote.flatMap { note in
            notes.firstIndex { $0.id == note.id }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


