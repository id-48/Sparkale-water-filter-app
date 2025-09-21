# Sparkale Water Filter App

A Flutter application built with MVC architecture and GetX state management for water filter management.

## 🏗️ Project Structure

```
lib/
├── core/                           # Core functionality
│   ├── constants/                  # App constants
│   │   ├── app_colors.dart        # Color definitions
│   │   ├── app_constants.dart     # App constants
│   │   └── app_strings.dart       # String constants
│   ├── theme/                      # Theme configuration
│   │   └── app_theme.dart         # App themes
│   ├── utils/                      # Utility functions
│   │   ├── logger.dart            # Logging utility
│   │   ├── preference_utils.dart  # SharedPreferences utility
│   │   └── validators.dart        # Input validators
│   └── widgets/                    # Common widgets
│       ├── error_widget.dart      # Error widgets
│       └── loading_widget.dart    # Loading widgets
├── features/                      # Feature modules
│   ├── splash/                    # Splash screen feature
│   │   └── presentation/
│   │       ├── bindings/
│   │       ├── controllers/
│   │       └── views/
│   └── home/                      # Home screen feature
│       └── presentation/
│           ├── bindings/
│           ├── controllers/
│           └── views/
├── routes/                        # App routing
│   └── app_pages.dart
└── main.dart                      # App entry point
```

## 🚀 Features

- **MVC Architecture**: Clean separation of concerns
- **GetX State Management**: Reactive state management
- **Custom Theme**: Beautiful water-themed UI
- **Logging**: Comprehensive logging system
- **Validation**: Input validation utilities
- **Common Widgets**: Reusable UI components

## 📦 Dependencies

- `get`: State management and routing
- `shared_preferences`: Local data storage
- `flutter_spinkit`: Loading indicators

## 🛠️ Getting Started

1. **Install dependencies**:
   ```bash
   flutter pub get
   ```

2. **Run the app**:
   ```bash
   flutter run
   ```

## 🎨 Architecture

### MVC Pattern
- **Model**: Data models and business logic
- **View**: UI components and screens
- **Controller**: State management and business logic

### GetX Integration
- **Controllers**: Manage state and business logic
- **Bindings**: Dependency injection
- **Views**: Reactive UI components
- **Routes**: Navigation management

## 🔧 Configuration


### Theme Customization
Modify colors and styles in `lib/core/theme/app_theme.dart` and `lib/core/constants/app_colors.dart`.

## 📱 Screens

1. **Splash Screen**: 3-second delay with app branding
2. **Home Screen**: Main dashboard with counter demo

## 🔍 Logging

The app includes comprehensive logging:
- Debug logs for development
- User action logging


## 💾 Data Persistence

- SharedPreferences for user data
- Secure token storage
- App settings persistence

## 🎯 Best Practices

- Clean code architecture
- Proper error handling
- Responsive UI design
- Performance optimization
- Code reusability

## 📄 License

This project is licensed under the MIT License.