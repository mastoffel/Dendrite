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
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            VStack {
                searchBar
                notesList
            }
            .frame(minWidth: 200)

            GeometryReader { geometry in
                VStack {
                    if let _ = selectedNote {
                        VStack(alignment: .leading, spacing: 16) {
                            TextField("Enter title here", text: Binding(get: { selectedNote?.title ?? "" }, set: { newTitle in
                                if let index = selectedNoteIndex {
                                    selectedNote?.title = newTitle
                                    notes[index].title = newTitle
                                }
                            }))
                            .font(.custom("Lato", size: 24))
                            .foregroundColor(.primary)
                            .padding(.bottom)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(.vertical, 0)

                            Divider()
                                .frame(width: geometry.size.width / 3)
                                .background(Color.primary)
                                .padding(.top, -10)

                            TextEditor(text: Binding(get: { selectedNote?.body ?? "" }, set: { newText in
                                if let index = selectedNoteIndex {
                                    selectedNote?.body = newText
                                    notes[index].body = newText
                                }
                            }))
                            .font(.custom("Lato", size: 16))
                            .foregroundColor(.primary)
                        }
                        .padding()
                        .background(Color.white) // set the background color of the child VStack to white
                        .cornerRadius(10) // add a corner radius to the child VStack
                        .shadow(radius: 5)
                    } else {
                        Text("Select or create a note")
                            .font(.custom("Lato", size: 24))
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
            }
        }
        .background(Color.clear)
    }
    
    private var searchBar: some View {
        HStack {
            TextField("Search", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: addNote) {
                Image(systemName: "plus")
            }
        }
        .padding()
    }
    
    private var notesList: some View {
        List(filteredNotes) { note in
            Button(action: { selectNote(note) }) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(note.title.isEmpty ? "Untitled" : note.title)
                            .font(.headline)
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
    
    private var filteredNotes: [Note] {
        notes.filter { note in
            searchText.isEmpty ||
            note.title.localizedCaseInsensitiveContains(searchText) ||
            note.body.localizedCaseInsensitiveContains(searchText)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



