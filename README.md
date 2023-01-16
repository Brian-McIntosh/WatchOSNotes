# WatchOSNotes
### Use FileManager to Store an Array as JSONEncoded Data to the Documents Directory
<img src="https://github.com/Brian-McIntosh/WatchOSNotes/blob/main/images/1.png" width="700">


TOPICS WILL BE COVERED:

* How to get familiar with the basics of the watchOS framework
* How to create multiple views and navigate between these views
* How to develop a standalone Apple Watch application with SwiftUI
* How to permanently save notes and store data on Apple Watch
* How to show a list of notes on Apple Watch
* How to select and delete notes from Apple Watch
* How to show SwiftUI views conditionally
* How to create and utilize uniform design language across pages
* How to use Swift's Codable protocol for serialization
* How to test a Watch app fullscreen in Simulator or on a device
* How to develop a new feature using SwiftUI's Slider element
* How to create custom user interface elements
* How to add icons and asset files to a Watch extension
* How to use the input tools: Dictate, Scribble, Emoji, Type

```swift
func getDocumentDirectory() -> URL {
    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return path[0]
}

// CRUD UPDATE:
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

// CRUD READ:
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

// CRUD DELETE:
func delete(offsets: IndexSet) {
    withAnimation {
        notes.remove(atOffsets: offsets)
        save()
    }
}

// CRUD CREATE:
// 2. Create a new item and initialize it with the text value
let note = Note(id: UUID(), text: text)

// 3. Add the new note item to the notes array (append)
notes.append(note)

// 4. Make the textfield empty
text = ""

// 5. Save the notes (function)
save()
```
