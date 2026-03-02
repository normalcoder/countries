import SwiftUI

struct CountryRowView: View {
    let country: Country

    var body: some View {
        HStack(spacing: 12) {
            flagThumbnail
            info
            Spacer(minLength: 0)
            Text(country.flagEmoji)
                .font(.title2)
                .accessibilityHidden(true)
        }
        .padding(.vertical, 2)
    }

    private var flagThumbnail: some View {
        CachedAsyncImage(url: URL(string: country.flags.png)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case .failure:
                Color.clear.overlay(
                    Text(country.flagEmoji).font(.title)
                )
            default:
                EmptyView()
            }
        }
        .frame(width: 52, height: 34)
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .strokeBorder(Color.secondary.opacity(0.25), lineWidth: 0.5)
        )
    }

    private var info: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(country.name.common)
                .font(.body)
                .fontWeight(.medium)
            
            Text("\(country.region)" + (country.capital?.first.map { ", \($0)" } ?? ""))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
