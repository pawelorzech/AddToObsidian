import SwiftUI
import AppKit

struct NoteInputView: View {
    @ObservedObject var viewModel: NoteViewModel
    @FocusState private var isTextEditorFocused: Bool
    var onSave: () -> Void
    var onCancel: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "note.text")
                    .foregroundColor(.secondary)
                Text("Quick Note to Obsidian")
                    .font(.headline)
                Spacer()

                if !viewModel.canSave {
                    Text("No vault selected")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }

            TextEditor(text: $viewModel.noteContent)
                .font(.body)
                .frame(minHeight: 150)
                .focused($isTextEditorFocused)
                .scrollContentBackground(.hidden)
                .background(Color(NSColor.textBackgroundColor))
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                )

            if viewModel.showError, let error = viewModel.errorMessage {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                    Spacer()
                }
            }

            HStack {
                Button("Cancel") {
                    onCancel()
                }
                .keyboardShortcut(.escape, modifiers: [])

                Spacer()

                Text("Cmd+Enter to save")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Button("Save") {
                    if viewModel.saveNote() {
                        onSave()
                    }
                }
                .keyboardShortcut(.return, modifiers: .command)
                .disabled(!viewModel.canSave || viewModel.noteContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .padding()
        .frame(width: 400, height: 280)
        .background(VisualEffectView(material: .hudWindow, blendingMode: .behindWindow))
        .onAppear {
            isTextEditorFocused = true
        }
    }
}

struct VisualEffectView: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode

    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }
}

#Preview {
    NoteInputView(
        viewModel: NoteViewModel(),
        onSave: {},
        onCancel: {}
    )
}
