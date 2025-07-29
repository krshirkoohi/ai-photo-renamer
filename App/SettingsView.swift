import SwiftUI
import AppKit
import UniformTypeIdentifiers

struct SettingsView: View {
    @AppStorage("apiKey") var apiKey = ""

    @State private var previewName: String?
    @State private var isProcessing = false

    var body: some View {
        Form {
            SecureField("OpenAI API Key", text: $apiKey)
            Button("Save to Keychain") {
                KeychainManager.save(apiKey: apiKey)
            }
            
            Button("Select Image & Preview Rename") {
                chooseImageAndPreview()
            }
            .disabled(apiKey.isEmpty || isProcessing)
            
            if let name = previewName {
                Text("Suggested filename: \(name)")
                    .font(.headline)
            }
        }
        .padding()
        .frame(maxWidth: 400)
    }

    // MARK: - Helpers
    private func chooseImageAndPreview() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.image]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.begin { response in
            guard response == .OK, let url = panel.url else { return }
            isProcessing = true
            Task {
                defer { isProcessing = false }
                guard let key = KeychainManager.retrieve(), !key.isEmpty else {
                    previewName = "No API key saved"
                    return
                }
                do {
                    if let suggestion = try await AIPhotoRenamer.describeImage(url, apiKey: key) {
                        previewName = suggestion + "." + url.pathExtension
                    }
                } catch {
                    previewName = "Error: \(error.localizedDescription)"
                }
            }
        }
}
}