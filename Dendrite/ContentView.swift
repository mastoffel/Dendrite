//
//  ContentView.swift
//  Dendrite
//
//  Created by Martin Stoffel on 19/03/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var notes: [Note]
    @State private var selectedNote: Note?
    @State private var searchText = ""

    init(notes: [Note] = []) {
        self._notes = State(initialValue: notes)
    }

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
                                    saveNotes()
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
                                    saveNotes()
                                }
                            }))
                            .font(.custom("Lato", size: 16))
                            .foregroundColor(.primary)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
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
        List {
            ForEach(filteredNotes) { note in
                Button(action: { selectNote(note) }) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(note.title.isEmpty ? "Untitled" : note.title)
                                .font(.headline)
                        }
                    }
                }
                .contextMenu {
                    Button(action: {
                        if let index = notes.firstIndex(where: { $0.id == note.id }) {
                            deleteNote(at: IndexSet(integer: index))
                        }
                    }) {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
    }



//    private var deleteButton: some View {
//        Button(action: deleteSelectedNote) {
//            Text("Delete")
//                .foregroundColor(.red)
//        }
//    }
    
    
    private func addNote() {
        let newNote = Note(title: "Untitled", body: "")
        notes.append(newNote)
        selectedNote = newNote
        saveNotes()
    }
    
    private func selectNote(_ note: Note) {
        selectedNote = note
    }
    
    private func deleteNote(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
        selectedNote = nil
        saveNotes()
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
        
    private func saveNotes() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(notes)
            UserDefaults.standard.set(data, forKey: "notes")
        } catch {
            print("Error encoding notes: \(error)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



