import Foundation

enum NetworkError: Error, LocalizedError, Equatable {
    case invalidURL
    case noData
    case decodingError
    case serverError(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL provided was invalid."
        case .noData:
            return "No data was received from the server."
        case .decodingError:
            return "Failed to decode the response from the server."
        case .serverError(let message):
            return "Server error: \(message)"
        }
    }
}
