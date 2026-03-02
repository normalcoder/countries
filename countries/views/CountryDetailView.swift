import SwiftUI

struct CountryDetailView: View {
    let country: Country
    var neighbours: [Country] = []

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                flagHeader
                VStack(spacing: 14) {
                    nameCard
                    statsGrid
                    if !country.languagesDisplay.isEmpty {
                        languagesSection(title: "Languages", icon: "character.bubble", items: country.languagesDisplay)
                    }
                    if !country.currenciesDisplay.isEmpty {
                        currenciesSection
                    }
                    if !neighbours.isEmpty {
                        bordersSection(neighbours)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }
        }
        .navigationTitle(country.name.common)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var flagHeader: some View {
        CachedAsyncImage(url: URL(string: country.flags.png)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            case .failure:
                Text(country.flagEmoji).font(.system(size: 80))
            default:
                ProgressView()
            }
        }
        .frame(height: 220)
    }

    private var nameCard: some View {
        VStack(spacing: 6) {
            Text(country.name.common)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            if country.name.official != country.name.common {
                Text(country.name.official)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var statsGrid: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ],
            spacing: 12
        ) {
            StatCardView(title: "Capital", value: country.capitalDisplay, icon: "building.columns")
            StatCardView(title: "Population", value: country.populationFormatted, icon: "person.3")
            StatCardView(title: "Region", value: country.region, icon: "map")
            StatCardView(title: "Codes", value: "\(country.cca2), \(country.cca3)", icon: "tag")
        }
    }

    private func languagesSection(title: String, icon: String, items: [String]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeaderView(title: title, icon: icon)
            FlowLayout(spacing: 8) {
                ForEach(items, id: \.self) { item in
                    TagView(label: item)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var currenciesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeaderView(title: "Currency", icon: "banknote")
            if let currency = country.currenciesDisplay.first {
                HStack {
                    Text(currency.name)
                        .font(.subheadline)
                    Spacer()
                    if !currency.symbol.isEmpty {
                        Text(currency.symbol)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func bordersSection(_ neighbours: [Country]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeaderView(title: "Neighbouring Countries", icon: "point.3.connected.trianglepath.dotted")
            FlowLayout(spacing: 8) {
                ForEach(neighbours, id: \.cca3) { neighbour in
                    borderChip(for: neighbour)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func borderChip(for neighbour: Country) -> some View {
        NavigationLink(value: neighbour) {
            TagView(label: "\(neighbour.flagEmoji) \(neighbour.name.common)")
        }
        .foregroundStyle(.primary)
    }
}

private struct StatCardView: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label(title, systemImage: icon)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

private struct SectionHeaderView: View {
    let title: String
    let icon: String

    var body: some View {
        Label(title, systemImage: icon)
            .font(.headline)
    }
}

private struct TagView: View {
    let label: String

    var body: some View {
        Text(label)
            .font(.subheadline)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color(.systemBackground))
            .clipShape(Capsule())
    }
}
