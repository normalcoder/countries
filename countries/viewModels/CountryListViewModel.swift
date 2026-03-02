import Foundation
import Observation

/// Implicitly `@MainActor` due to the `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor` build setting.
@Observable
final class CountryListViewModel {
    // Published state
    var countries: [Country] = []
    var searchText: String = ""
    var isLoading: Bool = false
    var error: CountriesServiceError?

    private let service: any CountriesService

    init(service: any CountriesService = DefaultCountriesService()) {
        self.service = service
    }

    var filteredCountries: [Country] {
        guard !searchText.isEmpty else {
            return countries
        }

        let query = searchText.lowercased()
        return countries.filter {
            $0.name.common.lowercased().contains(query) ||
            $0.name.official.lowercased().contains(query) ||
            $0.region.lowercased().contains(query) ||
            ($0.capital?.joined(separator: " ").lowercased().contains(query) ?? false)
        }
    }

    func loadCountries() async {
        isLoading = true
        defer { isLoading = false }
        
        error = nil
        do {
            countries = try await service.fetchAllCountries()
                .sorted { $0.population > $1.population }
        } catch {
            self.error = error as? CountriesServiceError
        }
    }

    func country(forCode code: String) -> Country? {
        countries.first { $0.cca3 == code }
    }
}
