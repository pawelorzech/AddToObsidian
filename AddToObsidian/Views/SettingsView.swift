import SwiftUI

struct SettingsView: View {
    @ObservedObject var settingsManager = SettingsManager.shared
    @State private var showingFolderPicker = false

    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Obsidian Vault Location")
                        .font(.headline)

                    HStack {
                        if let path = settingsManager.obsidianVaultPath {
                            Image(systemName: "folder.fill")
                                .foregroundColor(.blue)
                            Text(path.path)
                                .lineLimit(1)
                                .truncationMode(.middle)
                        } else {
                            Image(systemName: "folder")
                                .foregroundColor(.secondary)
                            Text("No folder selected")
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Button("Select Folder...") {
                        settingsManager.selectFolder { _ in }
                    }
                }
                .padding(.vertical, 8)
            }

            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Keyboard Shortcuts")
                        .font(.headline)

                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Open note window:")
                            Spacer()
                            Text("Control + Option + Cmd + O")
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(.secondary)
                        }

                        HStack {
                            Text("Save note:")
                            Spacer()
                            Text("Cmd + Enter")
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(.secondary)
                        }

                        HStack {
                            Text("Cancel:")
                            Spacer()
                            Text("Escape")
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.vertical, 8)
            }

            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("About")
                        .font(.headline)

                    Text("Notes are saved with YAML frontmatter containing the creation date. File names follow the format: yyyy-MM-dd_HH-mm-ss.md")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)
            }
        }
        .formStyle(.grouped)
        .frame(width: 450, height: 350)
    }
}

#Preview {
    SettingsView()
}
