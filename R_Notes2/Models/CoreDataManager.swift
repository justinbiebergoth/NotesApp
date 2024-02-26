import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager(modelName: "R_Notes2")

    let persistentContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext {

    return persistentContainer.viewContext
    }

    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }

    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }

            if self.fetchNotes().isEmpty {
                self.createFirstNote()
            }

            completion?()
        }
    }
    
    func save() {
        if viewContext.hasChanges {
            try? viewContext.save()
        }
    }

    func createFirstNote() {
        let firstNote = createNote()
        firstNote.text = "Ваша первая заметка тут"
        save()
    }
}

extension CoreDataManager {
    func createNote() -> Note {
        let note = Note(context: viewContext)
        note.id = UUID()
        note.text = ""
        note.lastUpdated = Date()
        save()
        return note
    }

    func fetchNotes() -> [Note] {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \Note.lastUpdated, ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        return (try? viewContext.fetch(request)) ?? []
    }

    func deleteNote(_ note: Note) {
        viewContext.delete(note)
        save()
    }
}
