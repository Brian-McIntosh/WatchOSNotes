//
//  ContentView.swift
//  WatchOSNotes Watch App
//
//  Created by Brian McIntosh on 1/9/23.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - PROPERTY
    @State private var notes: [Note] = [Note]()
    @State private var text: String = ""
    @AppStorage("lineCount") var lineCount: Int = 1
    
    // MARK: - FUNCTON
    func getDocumentDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    
    func save() {
        // dump(notes) // --> prints to console
        do {
            // 1. convert notes array to data using JSONEncoder
            let data = try JSONEncoder().encode(notes)
            
            // 2. create a new url to save the file using the getDoc...
            let url = getDocumentDirectory().appendingPathComponent("notes")
            
            // 3. write the data to the given url
            try data.write(to: url)
            
        } catch {
            print("Saving data has failed!")
        }
    }
    
    func load() {
        DispatchQueue.main.async {
            do {
                // 1. Get the notes URL path
                let url = getDocumentDirectory().appendingPathComponent("notes")
                
                // 2. Create a new property for the data
                let data = try Data(contentsOf: url)
                
                // 3. Decode the data
                notes = try JSONDecoder().decode([Note].self, from: data)
                
            } catch {
                // Do nothing
            }
        }
    }
    
    func delete(offsets: IndexSet) {
        withAnimation {
            notes.remove(atOffsets: offsets)
            save()
        }
    }
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                HStack(alignment: .center, spacing: 6) {
                    TextField("Add New Note", text: $text)
                    
                    Button {
                        //action - pseudo code!
                        //not enough to just state final goal
                        
                        // 1. Only run button's action when textfield is not empty
                        guard text.isEmpty == false else {
                            // error handling
                            // maybe show an alert that they have to enter text
                            print("inside guard")
                            return
                        }
                        print("outside guard")
                        /*
                         the guard statement runs when a certain condition is not met.
                             guard EXPRESSION else {
                               // statements
                               // control statement: return, break, continue or throw.
                             }
                            EXPRESSION returns either TRUE or FALSE.
                            TRUE - the code block IS NOT executed, and your program logic continues to flow
                            FALSE - the code block IS executed, meaning you exit and/or handle an error
                         */
                        
                        // 2. Create a new item and initialize it with the text value
                        let note = Note(id: UUID(), text: text)
                        
                        // 3. Add the new note item to the notes array (append)
                        notes.append(note)
                        
                        // 4. Make the textfield empty
                        text = ""
                        
                        // 5. Save the notes (function)
                        // simply prints(dumps) to console for now
                        save()
                        
                    } label: {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 42, weight: .semibold))
                    }
                    .fixedSize()
                    .buttonStyle(.plain)
                    .foregroundColor(.accentColor)
                    //.buttonStyle(.bordered).tint(.accentColor)
                }//: HSTACK
                
                Spacer()
                
                //Text("\(notes.count)")
                
                if notes.count >= 1 {
                    List {
                        ForEach(0..<notes.count, id: \.self) { i in
                            NavigationLink(destination: DetailView(note: notes[i], count: notes.count, index: i)) {
                                HStack {
                                    Capsule()
                                        .frame(width: 4)
                                        .foregroundColor(.accentColor)
                                    Text(notes[i].text)
                                        .lineLimit(lineCount) //started as 1
                                        .padding(.leading, 5)
                                }
                            }//: HSTACK
                        }//: LOOP
                        .onDelete(perform: delete)
                        
                    }
                } else {
                    Spacer()
                    Image(systemName: "note.text")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray)
                        .opacity(0.25)
                        .padding()
                    Spacer()
                } //: LIST
                
            } //: VSTACK
            .navigationTitle("Notes")
            .onAppear(perform: {
                load()
            })
        }
    }
}

// MARK: - PREVIEW

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
