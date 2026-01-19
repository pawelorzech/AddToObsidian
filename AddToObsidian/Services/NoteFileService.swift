import Foundation

enum NoteFileError: LocalizedError {
    case noVaultPath
    case writeError(Error)
    case invalidPath

    var errorDescription: String? {
        switch self {
        case .noVaultPath:
            return "No Obsidian vault folder selected. Please select a folder in Settings."
        case .writeError(let error):
            return "Failed to save note: \(error.localizedDescription)"
        case .invalidPath:
            return "The selected folder is no longer accessible."
        }
    }
}

class NoteFileService {
    static let shared = NoteFileService()

    private let settingsManager = SettingsManager.shared

    private init() {}

    func save(note: Note) throws -> URL {
        guard let vaultPath = settingsManager.obsidianVaultPath else {
            throw NoteFileError.noVaultPath
        }

        guard settingsManager.hasValidVaultPath else {
            throw NoteFileError.invalidPath
        }

        let fileURL = vaultPath.appendingPathComponent(note.filename)

        do {
            try note.fullContent.write(to: fileURL, atomically: true, encoding: .utf8)
            return fileURL
        } catch {
            throw NoteFileError.writeError(error)
        }
    }
}
