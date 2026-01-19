import Foundation

struct Note {
    let content: String
    let createdAt: Date

    init(content: String, createdAt: Date = Date()) {
        self.content = content
        self.createdAt = createdAt
    }

    var filename: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        return "\(formatter.string(from: createdAt)).md"
    }

    var frontmatter: String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime]
        let dateString = isoFormatter.string(from: createdAt)

        return """
        ---
        created: \(dateString)
        ---

        """
    }

    var fullContent: String {
        return frontmatter + content
    }
}
