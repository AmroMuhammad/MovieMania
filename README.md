# MovieMania

iOS app that lists trending movies from TMDB, with search, genre filtering, pagination, and offline caching.

Built with SwiftUI + Combine, Clean Architecture (Domain / Data / Presentation), and a modular `Networking` Swift Package.

## Setup

The app needs a TMDB v3 API key. The key is read from `Config/Secrets.xcconfig`, which is gitignored.

1. Get a v3 API key at https://www.themoviedb.org/settings/api
2. Navigate to project directory
3. Copy the sample config:
   ```sh
   cp Config/Secrets.sample.xcconfig Config/Secrets.xcconfig
   ```
4. Open `Config/Secrets.xcconfig` and replace `YOUR_TMDB_API_KEY_HERE` with your key.
5. Open `MovieMania.xcodeproj` and run.

The key flows: `Config/Secrets.xcconfig` → build setting `TMDBAPIKey` → `${TMDBAPIKey}` substitution in `MovieMania/Info.plist` → `Bundle.main.object(forInfoDictionaryKey: "TMDBAPIKey")` in `Secrets.swift`.

If the key is missing at runtime, the app fails fast with a `fatalError` pointing at the Info.plist read.

## Tests

```sh
xcodebuild test -project MovieMania.xcodeproj -scheme MovieMania -destination 'platform=iOS Simulator,name=iPhone 15'
```
