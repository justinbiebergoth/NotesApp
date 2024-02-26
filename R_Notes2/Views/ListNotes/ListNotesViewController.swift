import UIKit

protocol ListNotesDelegate: AnyObject {
    func refreshNotes()
    func deleteNote(with id: UUID)
}

class ListNotesViewController: UIViewController {
    
    @IBOutlet weak private var tableView: UITableView!

    private var filteredNotes: [Note] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.shadowImage = UIImage()
        tableView.contentInset = .init(top: 0, left: 0, bottom: 30, right: 0)
        fetchNotesFromStorage()
    }

    private func indexForNote(id: UUID, in list: [Note]) -> IndexPath {
        let row = Int(list.firstIndex(where: { $0.id == id }) ?? 0)
        return IndexPath(row: row, section: 0)
    }

    @IBAction func createNewNoteClicked(_ sender: UIButton) {
        goToEditNote(createNote())
    }

    private func goToEditNote(_ note: Note) {
        let controller = storyboard?.instantiateViewController(identifier: EditNoteViewController.identifier) as! EditNoteViewController
        controller.note = note
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }

    private func createNote() -> Note {
        let note = CoreDataManager.shared.createNote()
        filteredNotes.insert(note, at: 0)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)

        return note
    }

    private func fetchNotesFromStorage() {
        filteredNotes = CoreDataManager.shared.fetchNotes()
        print("Fetching all notes")
    }

    private func deleteNoteFromStorage(_ note: Note) {
        deleteNote(with: note.id)
        CoreDataManager.shared.deleteNote(note)
    }
}

// MARK: TableView Configuration
extension ListNotesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListNoteTableViewCell.identifier) as! ListNoteTableViewCell
        cell.setup(note: filteredNotes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goToEditNote(filteredNotes[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteNoteFromStorage(filteredNotes[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
// MARK:- ListNotes Delegate
extension ListNotesViewController: ListNotesDelegate {

    func refreshNotes() {
        filteredNotes = filteredNotes.sorted(by: { $0.lastUpdated > $1.lastUpdated })
        tableView.reloadData()
    }

    func deleteNote(with id: UUID) {
        let indexPath = indexForNote(id: id, in: filteredNotes)
        filteredNotes.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)

        if let allNotesIndex = filteredNotes.firstIndex(where: { $0.id == id }) {
        filteredNotes.remove(at: allNotesIndex)
        }
    }
}
