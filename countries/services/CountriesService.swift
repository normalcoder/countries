import Foundation

protocol CountriesService {
    func fetchAllCountries() async throws -> [Country]
}

actor DefaultCountriesService: CountriesService {
    private let session = URLSession.shared

    /// Fields fetched from the API. The REST Countries v3.1 API enforces maximum of 10 fields per request
    private nonisolated static let fields = "name,flags,cca2,cca3,capital,population,region,borders,languages,currencies"

    func fetchAllCountries() async throws -> [Country] {
        let url = try buildURL()
        let (data, _) = try await fetch(url: url)
        return try decode(data: data)
    }

    private func buildURL() throws -> URL {
        var components = URLComponents(string: "https://restcountries.com/v3.1/all")!
        components.queryItems = [URLQueryItem(name: "fields", value: Self.fields)]
        guard let url = components.url else {
            throw CountriesServiceError.networkError(
                URLError(.badURL)
            )
        }
        return url
    }

    private func fetch(url: URL) async throws -> (Data, URLResponse) {
        do {
            return try await session.data(from: url)
        } catch {
            throw CountriesServiceError.networkError(error)
        }
    }

    private func decode(data: Data) throws -> [Country] {
        do {
            return try JSONDecoder().decode([Country].self, from: data)
        } catch {
            throw CountriesServiceError.decodingFailed(error)
        }
    }
}


enum CountriesServiceError: LocalizedError {
    case invalidResponse(Int)
    case decodingFailed(Error)
    case networkError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidResponse(let code):
            return "The server returned an invalid response (HTTP \(code))."
        case .decodingFailed:
            return "Failed to process country data. Please try again."
        case .networkError(let error):
            return error.localizedDescription
        }
    }
}
