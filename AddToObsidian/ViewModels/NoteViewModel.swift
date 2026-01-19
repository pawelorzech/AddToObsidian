import Foundation
import SwiftUI

class NoteViewModel: ObservableObject {
    @Published var noteContent: String = ""
    @Published var errorMessage: String?
    @Published var showError: Bool = false

    private let fileService = NoteFileService.shared
    let settingsManager = SettingsManager.shared

    func saveNote() -> Bool {
        let trimmedContent = noteContent.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedContent.isEmpty else {
            showErrorMessage("Cannot save an empty note.")
            return false
        }

        let note = Note(content: trimmedContent)

        do {
            let savedURL = try fileService.save(note: note)
            print("Note saved to: \(savedURL.path)")
            clearNote()
            return true
        } catch {
            showErrorMessage(error.localizedDescription)
            return false
        }
    }

    func clearNote() {
        noteContent = ""
        errorMessage = nil
        showError = false
    }

    private func showErrorMessage(_ message: String) {
        errorMessage = message
        showError = true
    }

    var canSave: Bool {
        settingsManager.hasValidVaultPath
    }
}
