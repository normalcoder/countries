import SwiftUI

struct CountryListView: View {
    @Bindable var viewModel: CountryListViewModel

    var body: some View {
        content
            .navigationTitle("Countries")
            .searchable(
                text: $viewModel.searchText,
                prompt: "Search countries, capitals..."
            )
            .task {
                if viewModel.countries.isEmpty {
                    await viewModel.loadCountries()
                }
            }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.countries.isEmpty {
            loadingView
        } else if let error = viewModel.error, viewModel.countries.isEmpty {
            errorView(error)
        } else {
            countryList
        }
    }

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
            Text("Loading countries...")
                .foregroundStyle(.secondary)
        }
    }

    private func errorView(_ error: any LocalizedError) -> some View {
        ContentUnavailableView {
            Label("Unable to Load Countries", systemImage: "wifi.slash")
        } description: {
            Text(error.localizedDescription)
        } actions: {
            Button("Try Again") {
                Task { await viewModel.loadCountries() }
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private var countryList: some View {
        List {
            ForEach(viewModel.filteredCountries) { country in
                countryRow(country)
            }
        }
        .refreshable {
            await viewModel.loadCountries()
        }
        .overlay {
            if viewModel.filteredCountries.isEmpty && !viewModel.isLoading {
                emptyState
            }
        }
        .animation(.default, value: viewModel.filteredCountries.map(\.id))
    }


    private func countryRow(_ country: Country) -> some View {
        NavigationLink(value: country) {
            CountryRowView(country: country)
        }
    }

    private var emptyState: some View {
        ContentUnavailableView(
            "No Results",
            systemImage: "magnifyingglass",
            description: Text("No countries matched \"\(viewModel.searchText)\".")
        )
    }
}
