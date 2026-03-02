import SwiftUI

struct ContentView: View {
    @State private var viewModel = CountryListViewModel()

    var body: some View {
        NavigationStack {
            CountryListView(viewModel: viewModel)
                .navigationDestination(for: Country.self) { country in
                    CountryDetailView(
                        country: country,
                        neighbours: country.borders?.compactMap { viewModel.country(forCode: $0) } ?? []
                    )
                }
        }
    }
}

#Preview {
    ContentView()
}
