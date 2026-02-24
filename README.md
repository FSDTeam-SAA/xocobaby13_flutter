# Xocobaby13

Xocobaby13 is a Flutter app with onboarding, authentication, chat, profile, and navigation flows. The project uses GetX for dependency injection and reactive controllers, GoRouter for navigation, and a small service layer around API access. The UI is organized by feature, with shared design tokens and widgets in `lib/core/`.

## Overview

- App name: Xocobaby13
- Platforms: iOS, Android, Web, Desktop (Flutter)
- SDK: Flutter (Dart `^3.11.0`)
- Version: `1.0.0+1`
- State/DI: GetX (`get`)
- Routing: GoRouter (`go_router`)
- Networking: `app_pigeon` + `dio`

## Feature Set

- Onboarding splash and multi-step onboarding pages
- Authentication: login, signup, email/OTP verification, forgot/reset/change password
- Chat: thread list, conversation view, message bubbles, search, input bar
- Profile: profile overview, edit profile, personal details, update password, activity list, logout
- Navigation: custom bottom navigation and main shell

## App Flow (High Level)

1. App launch
2. Onboarding splash and onboarding pages
3. Authentication screens
4. Main shell with bottom navigation
5. Feature screens (Chat, Profile, Activity, Settings)

## Architecture Notes

- Feature-first layout: each feature owns its screens, routes, widgets, models, and controllers.
- Shared UI, themes, helpers, and API utilities live in `lib/core/`.
- Dependency injection is wired in `lib/main.dart` using GetX and `externalServiceDI()`.
- API calls use `app_pigeon` with a refresh-token manager configured in `lib/core/di/external_service_di.dart`.
- Routes are registered in `lib/app/routes/app_routes.dart` using GoRouter.

## Project Structure

```
lib/
  main.dart                         # App entry point
  app/                              # App-level controllers and splash
  core/                             # Shared UI, helpers, services, theme, API utils
  feature/                          # Feature modules
    auth/                           # Onboarding + authentication flows
    chat/                           # Chat list + detail
    navigation/                     # Bottom navigation and main shell
    profile/                        # Profile, activity, settings
  src/                              # Legacy/shared utilities (not wired from main)
assets/
  images/                           # General images
  images/chat/                      # Chat avatars and assets
  onboarding/                       # Onboarding graphics
```

## Configuration

- API base and socket URLs: `lib/core/constants/api_endpoints.dart`
- Token refresh wiring: `lib/core/di/external_service_di.dart`
- Theme and colors: `lib/core/theme/`

If running on a device or emulator, make sure `baseUrl` and `socketUrl` are reachable from that device.

## Dependencies (Key)

- `get`: state and dependency management
- `go_router`: declarative routing
- `app_pigeon`: API + auth token storage/refresh
- `dio`: HTTP client
- `dartz`: Either/Result helpers
- `image_picker`: profile avatar selection
- `google_fonts`, `intl`, `pinput`, `path_provider`

## Getting Started

1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. Configure API endpoints:
   - Update `lib/core/constants/api_endpoints.dart`.

3. Run the app:
   ```bash
   flutter run
   ```

## Testing

```bash
flutter test
```

## Notes

- Chat and profile screens include local sample data for UI development.
- Keep secrets out of source control. Configure production endpoints and keys via secure build configs.
