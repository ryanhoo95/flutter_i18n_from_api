# Flutter i18n from API

This app demonstrates multi-languages support with Flutter.

### Problem Statement

Oftenly, we need to add multiple languages to our app. This could be done in many ways. Mostly, we add the language files in our app. But, what if you want to update certain label in certain page after the app was published to the store. This could waste a lot of time to just update that particular label in your language file, and then republish the app.

### Solution
To solve this issue, we could upload all the labels with their respective key to the server. When the app is launched, we could retrieve all the labels from server and store it in local files. Whenever you want to update the label, we just need to update its value in server.

### Assumption & Limitation

- The app does not make the real API call, it's just simulating the process of getting labels from API.
- The app will simulate API call and save the raw string in local file everytime the app was launched. For best practice, you should have label version update to control when to download and save the labels.

## Let's Get Started!

### 1. pubspec dependencies

Add the following dependencies to [pubspec.yaml](https://github.com/ryanhoo95/flutter_i18n_from_api/blob/master/pubspec.yaml):
-  [flutter_localizations](https://flutter.dev/docs/development/accessibility-and-localization/internationalization) -> to support multi-languages
-  [shared_preferences](https://pub.dev/packages/shared_preferences) -> to save current app language used by the user
-  [path_provider](https://pub.dev/packages/path_provider) -> to save the raw labels retrived from API in local file
-  [provider](https://pub.dev/packages/provider) -> notify the app to update the UI accordingly whenever user switch app language

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter

  # The following adds the Cupertino Icons font to your application.
  # Use with the CupertinoIcons class for iOS style icons.
  cupertino_icons: ^1.0.0
  shared_preferences: ^0.5.12+4
  path_provider: ^1.6.24
  provider: ^4.3.2+2
```
