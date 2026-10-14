import Foundation

enum LocalJSONLoaderError: LocalizedError {
    case fileNotFound(String)
    case unreadableFile(String)
    case decodingFailed(String, Error)

    var errorDescription: String? {
        switch self {
        case .fileNotFound(let name):
            "Could not find local JSON file: \(name).json"
        case .unreadableFile(let name):
            "Could not read local JSON file: \(name).json"
        case .decodingFailed(let name, let error):
            "Could not decode \(name).json: \(error.localizedDescription)"
        }
    }
}

struct LocalJSONLoader {
    private let bundle: Bundle
    private let decoder: JSONDecoder

    init(bundle: Bundle = .main, decoder: JSONDecoder = JSONDecoder()) {
        self.bundle = bundle
        self.decoder = decoder
    }

    func decode<T: Decodable>(_ type: T.Type, from resourceName: String) throws -> T {
        guard let url = bundle.url(forResource: resourceName, withExtension: "json") ?? bundle.url(forResource: resourceName, withExtension: "json", subdirectory: "CareerKnowledge") else {
            throw LocalJSONLoaderError.fileNotFound(resourceName)
        }

        guard let data = try? Data(contentsOf: url) else {
            throw LocalJSONLoaderError.unreadableFile(resourceName)
        }

        do {
            return try decoder.decode(type, from: data)
        } catch {
            throw LocalJSONLoaderError.decodingFailed(resourceName, error)
        }
    }
}
