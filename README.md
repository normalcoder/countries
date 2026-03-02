# Countries

An iOS app for browsing country information

---

## Overview

The app lets users explore all countries in the world: search, browse a list, and dive into a detail page with key facts, the national flag, languages, currency, and clickable neighbouring countries.

Data is sourced from the [REST Countries v3.1 API](https://restcountries.com).

---

## Architecture

The app follows MVVM.
- `CountryListView` - search, list, pull to refresh;
- `CountryDetailView` - details.

- `CountryListViewModel` contains observable state for `CountryListView`.

- `CountriesService` — API client.
- `ImageCache` - In memory image cache (NSCache).


### Decisions

- `DefaultCountriesService` is an `actor`, which gives compile time data race safety.

- `CountriesService` is a protocol, so the view model depends only on the abstraction. Can be swapped in a mock for tests or SwiftUI previews.

- `CachedAsyncImage` wraps `URLSession` + `NSCache`, so flag images are cached.

---

## Features

- Country list.
- Search by name (common + official), capital, region.
- Pull to refresh.
- Flag display PNG via `CachedAsyncImage`, emoji fallback on failure.
- Country detail: flag, official name, capital, population, region, ISO codes, language, currency, neighbours.
- Neighbour navigation, tapping a neighbour pushes its detail view onto the stack.
- Error and empty states.
- Dark mode.

---

## Known Issues

- **No offline support.** There is no disk cache for the country list JSON. A cold launch without network shows an error state.
- **REST Countries field limit.** The API enforces a maximum of 10 fields per request. The current field set (`name, flags, cca2, cca3, capital, population, region, borders, languages, currencies`) is already at the limit; adding more data points would require a second request or dropping an existing field.

---

## Possible Further Development

- **Disk cache for the country list** — persist the JSON response to disk so the app is usable offline after the first launch.
- **Favourites** — persist a list of favourite countries across sessions using SwiftData.
- **Sorting and filtering** — sort by name, area, or population, filter by region or continent.
- **Maps integration** — link out to Apple Maps or open coordinates in the Maps app.
- **Unit tests** — the `CountriesService` protocol and `CountryListViewModel` are already structured for testability; adding XCTest coverage for the view model logic would be straightforward.
