# Weather App

A Flutter application that provides weather forecasts using the OpenWeather API.

## Features

- Search for weather forecasts by city name.
- View current weather conditions and a 5-day forecast.
- Toggle between Celsius and Fahrenheit units.
- Responsive and clean UI with theming support.
- Error handling for various edge cases.

## Architecture

The app follows a modular architecture with the following components:

- **BLoC (Business Logic Component) Pattern**: Used for state management.
- **Repository Pattern**: Used to abstract the data layer.
- **API Client**: Used to interact with the OpenWeather API.
- **Dependency Injection**: Used to provide dependencies to the BLoC components.

## Getting Started

### Prerequisites

- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- OpenWeather API Key: [Get API Key](https://openweathermap.org/api)

### Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/your-username/weather_app.git
   ```
2. Install dependencies:
   ```sh
   cd weather_app
   flutter pub get
   ```
3. Run the app:
   ```sh
   flutter run --dart-define=OPEN_WEATHER_API_KEY=your_api_key
   ```

### Project Structure
```
lib/
├── app/
│   └── app.dart
├── cubits/
│   ├── cubits.dart
│   └── weather/
│       ├── weather_cubit.dart
│       ├── weather_state.dart
│       └── data_state.dart
├── models/
│   ├── display_weather.dart
│   ├── temperature_unit.dart
│   └── weather_condition.dart
├── pages/
│   ├── search/
│   │   ├── search.dart
│   │   └── view/
│   │       └── search_page.dart
│   ├── settings/
│   │   ├── settings.dart
│   │   └── view/
│   │       └── settings_page.dart
│   └── weather/
│       ├── components/
│       │   ├── components.dart
│       │   ├── weather_background.dart
│       │   ├── weather_empty.dart
│       │   ├── weather_error.dart
│       │   ├── weather_forecast.dart
│       │   ├── weather_loading.dart
│       │   └── weather_populated.dart
│       └── view/
│           └── weather_page.dart
├── utils/
│   └── extensions/
│       └── date_time_extension.dart
├── weather_bloc_observer.dart
└── main.dart
```

### Packages Structure
#### OpenWeather API Package
```
packages/open_weather_api/
├── lib/
│   ├── open_weather_api.dart
│   ├── src/
│   │   ├── models/
│   │   │   ├── weather.dart
│   │   │   ├── weather.g.dart
│   │   │   ├── weather_forecast.dart
│   │   │   └── weather_forecast.g.dart
│   │   ├── open_weather_client.dart
│   │   └── open_weather_exception.dart
├── test/
│   └── open_weather_api_test.dart
└── pubspec.yaml
```

#### Weather Repository Package
```
packages/weather_repository/
├── lib/
│   ├── weather_repository.dart
│   ├── src/
│   │   ├── models/
│   │   │   ├── weather.dart
│   │   │   └── weather_forecast.dart
│   │   ├── weather_repository.dart
│   │   └── weather_repository_exception.dart
├── test/
│   └── weather_repository_test.dart
└── pubspec.yaml
```
