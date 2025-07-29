import AppKit
import UniformTypeIdentifiers

struct RenameWithAI: FinderExtensionCommand {
    let title = "Rename with AI"

    func perform(with selectedItems: [URL]) async throws {
        guard let apiKey = KeychainManager.retrieve() else { return }

        for fileURL in selectedItems {
            if fileURL.conforms(to: .image) {
                if let newName = try? await AIPhotoRenamer.describeImage(fileURL, apiKey: apiKey) {
                    let newURL = fileURL.deletingLastPathComponent()
                        .appendingPathComponent(newName + "." + fileURL.pathExtension)
                    try? FileManager.default.moveItem(at: fileURL, to: newURL)
                }
            }
        }
    }
}