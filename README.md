# Architecture Documentation

## Overview

The application follows a **Layered Architecture** with a strong emphasis on **Feature-First** organization and **Modularization** using local packages. It uses **BLoC (Business Logic Component)** for state management, ensuring a clear separation between the UI and business logic.

## High-Level Structure

```
flutter_sample/
├── lib/
│   ├── app/                 # App-wide configuration, root widget, and global providers
│   ├── pages/               # Feature pages (Screens)
│   │   ├── weather/         # Weather feature (UI + Logic)
│   │   ├── search/          # Search feature
│   │   ├── favorites/       # Favorites feature
│   │   └── settings/        # Settings feature
│   ├── main_*.dart          # Entry points for different flavors (dev, stage, prod)
│   └── flavor_config.dart   # Environment configuration
├── packages/
│   ├── weather_repository/  # Domain layer: Abstract repository for weather data
│   └── open_meteo_api/      # Data layer: API client for OpenMeteo
└── pubspec.yaml             # Dependencies
```

## Layers

### 1. Presentation Layer (`lib/pages`)
This layer is responsible for the UI and user interaction. It is organized by feature.
- **Widgets**: Dumb components that render data.
- **Pages**: Screens that connect Widgets to Cubits/Blocs.
- **Cubits/Blocs**: Manage the state of the view. They interact with Repositories to fetch data and emit states to the UI.
    - *Example*: `WeatherCubit` manages the state of the `WeatherPage`.

### 2. Domain Layer (`packages/weather_repository`)
This layer acts as the source of truth for the application's data. It abstracts the underlying data sources (API, Database, Device Sensors).
- **Repositories**: `WeatherRepository` coordinates data fetching. It combines data from the API client and Location repository (device location).
- **Models**: Domain entities like `Weather` and `Location` that are used throughout the app.
- **Responsibilities**:
    - Data transformation (API DTOs -> Domain Models).
    - Error handling (wrapping low-level exceptions into Domain Exceptions).

### 3. Data Layer (`packages/open_meteo_api`)
This layer handles the raw data retrieval.
- **API Clients**: `OpenMeteoApiClient` performs HTTP requests to the OpenMeteo API.
- **DTOs**: Data Transfer Objects representing the raw JSON response structure.

## State Management

The app uses the **BLoC** pattern (specifically `Cubit` for simpler use cases) via the `flutter_bloc` package.
- **Global State**: `WeatherCubit` and `FavoritesCubit` are provided at the top of the widget tree (`WeatherApp`), making them accessible globally.
- **Dependency Injection**: `RepositoryProvider` is used to inject `WeatherRepository` into the widget tree, which is then consumed by the Cubits.

## Navigation

- **Bottom Navigation**: Managed in `WeatherAppView` using a `BottomNavigationBar` and a local state `_selectedIndex`.
- **Page Navigation**: Standard Flutter `Navigator` is used for pushing new screens (e.g., from Search to Weather).

## Flavor Management

The app supports multiple environments (Development, Staging, Production) via:
- **Entry Points**: `main_development.dart`, `main_staging.dart`, `main_production.dart`.
- **Config**: `FlavorConfig` holds environment-specific variables like API Base URLs.

## Key Data Flow

1.  **User Action**: User searches for a city in `SearchPage`.
2.  **Cubit**: `SearchCubit` calls `WeatherRepository.searchLocations(query)`.
3.  **Repository**: `WeatherRepository` delegates to `OpenMeteoApiClient.locationSearchSuggestions(query)`.
4.  **API Client**: Makes HTTP request, parses JSON to DTOs.
5.  **Repository**: Maps DTOs to `Location` domain models and returns them.
6.  **Cubit**: Emits `SearchSuccess` state with the list of locations.
7.  **UI**: `SearchPage` rebuilds to show the list of results.
