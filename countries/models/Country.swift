import Foundation

struct Country: Codable, Identifiable, Hashable, Sendable {
    let name: Name
    let cca2: String
    let cca3: String
    let capital: [String]?
    let region: String
    let population: Int
    let flags: Flags
    let languages: [String: String]?
    let currencies: [String: Currency]?
    let borders: [String]?

    var id: String { cca2 }

    struct Name: Codable, Hashable, Sendable {
        let common: String
        let official: String
    }

    struct Flags: Codable, Hashable, Sendable {
        let png: String
        let svg: String?
        let alt: String?
    }

    struct Currency: Codable, Hashable, Sendable {
        let name: String
        let symbol: String?
    }
}

extension Country {
    /// Emoji flag from ISO 3166-1 alpha-2 code.
    var flagEmoji: String {
        let base: UInt32 = 0x1F1E6 - 0x41 // "🇦" - "A"
        return cca2.uppercased().unicodeScalars
            .compactMap { UnicodeScalar(base + $0.value) }
            .map(String.init)
            .joined()
    }

    var capitalDisplay: String {
        capital?.joined(separator: ", ") ?? "N/A"
    }

    var languagesDisplay: [String] {
        languages?.values.sorted() ?? []
    }

    var currenciesDisplay: [(name: String, symbol: String)] {
        currencies?.values.map { (name: $0.name, symbol: $0.symbol ?? "") } ?? []
    }

    var populationFormatted: String {
        population.formatted(.number)
    }
}
