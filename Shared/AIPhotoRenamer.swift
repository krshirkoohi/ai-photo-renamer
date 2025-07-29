import Foundation

enum AIPhotoRenamer {
    static func describeImage(_ url: URL, apiKey: String) async throws -> String? {
        let imageData = try Data(contentsOf: url)

        let prompt = "Describe this image with a short 3-5 word lowercase filename, using hyphens between words."

        let json: [String: Any] = [
            "model": "gpt-4o",
            "messages": [
                ["role": "system", "content": prompt],
                ["role": "user", "content": [
                    ["type": "image_url", "image_url": [
                        "url": "data:image/jpeg;base64,\(imageData.base64EncodedString())"
                    ]]
                ]]
            ]
        ]

        var request = URLRequest(url: URL(string: "https://api.openai.com/v1/chat/completions")!)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: json)

        let (data, _) = try await URLSession.shared.data(for: request)
        let result = try JSONDecoder().decode(OpenAIResponse.self, from: data)
        return result.choices.first?.message.content
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: " ", with: "-")
            .lowercased()
    }
}