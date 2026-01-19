import Foundation
import AppKit

class SettingsManager: ObservableObject {
    static let shared = SettingsManager()

    private let obsidianVaultPathKey = "obsidianVaultPath"
    private let obsidianVaultBookmarkKey = "obsidianVaultBookmark"

    @Published var obsidianVaultPath: URL? {
        didSet {
            if let path = obsidianVaultPath {
                UserDefaults.standard.set(path.path, forKey: obsidianVaultPathKey)
                saveSecurityScopedBookmark(for: path)
            } else {
                UserDefaults.standard.removeObject(forKey: obsidianVaultPathKey)
                UserDefaults.standard.removeObject(forKey: obsidianVaultBookmarkKey)
            }
        }
    }

    private init() {
        loadSavedPath()
    }

    private func loadSavedPath() {
        // Try to restore from security-scoped bookmark first
        if let bookmarkData = UserDefaults.standard.data(forKey: obsidianVaultBookmarkKey) {
            do {
                var isStale = false
                let url = try URL(
                    resolvingBookmarkData: bookmarkData,
                    options: .withSecurityScope,
                    relativeTo: nil,
                    bookmarkDataIsStale: &isStale
                )

                if isStale {
                    // Bookmark is stale, try to create a new one
                    saveSecurityScopedBookmark(for: url)
                }

                if url.startAccessingSecurityScopedResource() {
                    obsidianVaultPath = url
                    return
                }
            } catch {
                print("Failed to resolve bookmark: \(error)")
            }
        }

        // Fallback to plain path (may not have permissions)
        if let pathString = UserDefaults.standard.string(forKey: obsidianVaultPathKey) {
            obsidianVaultPath = URL(fileURLWithPath: pathString)
        }
    }

    private func saveSecurityScopedBookmark(for url: URL) {
        do {
            let bookmarkData = try url.bookmarkData(
                options: .withSecurityScope,
                includingResourceValuesForKeys: nil,
                relativeTo: nil
            )
            UserDefaults.standard.set(bookmarkData, forKey: obsidianVaultBookmarkKey)
        } catch {
            print("Failed to save bookmark: \(error)")
        }
    }

    func selectFolder(completion: @escaping (Bool) -> Void) {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.message = "Select your Obsidian vault folder"
        panel.prompt = "Select"

        panel.begin { response in
            if response == .OK, let url = panel.url {
                self.obsidianVaultPath = url
                completion(true)
            } else {
                completion(false)
            }
        }
    }

    var hasValidVaultPath: Bool {
        guard let path = obsidianVaultPath else { return false }
        var isDirectory: ObjCBool = false
        return FileManager.default.fileExists(atPath: path.path, isDirectory: &isDirectory) && isDirectory.boolValue
    }
}
