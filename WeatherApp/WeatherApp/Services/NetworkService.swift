import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case noData
    case decodingFailed
    case serverError(Int)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Некорректный URL"
        case .noData: return "Данные не получены"
        case .decodingFailed: return "Ошибка обработки данных"
        case .serverError(let code): return "Ошибка сервера: \(code)"
        }
    }
}

final class NetworkService {

    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
    }

    func request<T: Decodable>(_ url: URL) async throws -> T {
        let (data, response) = try await session.data(from: url)

        if let httpResponse = response as? HTTPURLResponse,
           !(200...299).contains(httpResponse.statusCode) {
            throw NetworkError.serverError(httpResponse.statusCode)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}
