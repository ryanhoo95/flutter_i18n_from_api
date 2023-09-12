# Flutter i18n from API

This app demonstrates multi-languages support with Flutter.

Refer [here](https://api.flutter.dev/flutter/flutter_localizations/GlobalMaterialLocalizations-class.html) for all the supported locales in Flutter.

### Problem Statement

Oftenly, we need to add multiple languages to our app. This could be done in many ways. Mostly, we add the language files in our app. But, what if you want to update certain label in certain page after the app was published to the store. This could waste a lot of time to just update that particular label in your language file, and then republish the app.

### Solution

To solve this issue, we could upload all the labels with their respective key to the server. When the app is launched, we could retrieve all the labels from server and store it in local files. Whenever you want to update the label, we just need to update its value in server.

### Assumption & Limitation

- The app does not make the real API call, it's just simulating the process of getting labels from API.
- The app will simulate API call and save the raw string in local file everytime the app was launched. For best practice, you should have label version update to control when to download and save the labels.

#### Screenshot

| English                                                                                                                                                                                                                                                             | Malay                                                                                                                                                                                                                                                               | Mandarin                                                                                                                                                                                                                                                            |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| <img src="https://user-images.githubusercontent.com/20148969/99642544-980e7280-2a86-11eb-8d53-de43a372ceb3.JPEG" width="120px" /> <img src="https://user-images.githubusercontent.com/20148969/99642585-a0ff4400-2a86-11eb-88bf-d090889f73a5.JPEG" width="120px" /> | <img src="https://user-images.githubusercontent.com/20148969/99642556-9b096300-2a86-11eb-8994-103b60c56ee8.JPEG" width="120px" /> <img src="https://user-images.githubusercontent.com/20148969/99642601-a3fa3480-2a86-11eb-94bf-2be15feee2bb.JPEG" width="120px" /> | <img src="https://user-images.githubusercontent.com/20148969/99642567-9e045380-2a86-11eb-97e7-3a8f8ba76730.JPEG" width="120px" /> <img src="https://user-images.githubusercontent.com/20148969/99642609-a6f52500-2a86-11eb-8e46-9e044ee98a0d.JPEG" width="120px" /> |

[Sample APK](https://github.com/ryanhoo95/flutter_i18n_from_api/blob/master/sample_apk/flutter_i18n.apk)

## Let's Get Started!

### 1. Dependencies

Add the following dependencies to [pubspec.yaml](https://github.com/ryanhoo95/flutter_i18n_from_api/blob/master/pubspec.yaml):

- [flutter_localizations](https://flutter.dev/docs/development/accessibility-and-localization/internationalization) -> to support multi-languages
- [shared_preferences](https://pub.dev/packages/shared_preferences) -> to save current app language used by the user
- [path_provider](https://pub.dev/packages/path_provider) -> to save the raw labels retrived from API in local file
- [provider](https://pub.dev/packages/provider) -> notify the app to update the UI accordingly whenever user switch app language

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

### 2. Mock API

Create a [MockApi](https://github.com/ryanhoo95/flutter_i18n_from_api/blob/master/lib/api/mock_api.dart) class to return sample json of labels. The app is currently supporting locale of 'en', 'ms' and 'zh'. The key is used as an identifier wherease the value is what we display on the UI.

```json
{
  "label": {
    "en": [
      {
        "key": "Greeting_Message",
        "value": "Hello, User"
      },
      {
        "key": "Greeting_Question",
        "value": "How are you?"
      },
      {
        "key": "Date_Hint",
        "value": "Date"
      }
    ],
    "ms": [
      {
        "key": "Greeting_Message",
        "value": "Hi, Pengguna"
      },
      {
        "key": "Greeting_Question",
        "value": "Apa khabar?"
      },
      {
        "key": "Date_Hint",
        "value": "Tarikh"
      }
    ],
    "zh": [
      {
        "key": "Greeting_Message",
        "value": "你好，用户"
      },
      {
        "key": "Greeting_Question",
        "value": "你好吗？"
      },
      {
        "key": "Date_Hint",
        "value": "日期"
      }
    ]
  }
}
```

### 3. Label Key

Create a [label_key.dart](https://github.com/ryanhoo95/flutter_i18n_from_api/blob/master/lib/language/label_key.dart) to save all the label key.

_Hint: use for loop to print out all the key when your app have tons of labels_ :smile:

```dart
const Greeting_Message = 'Greeting_Message';
const Greeting_Question = 'Greeting_Question';
const Date_Hint = 'Date_Hint';
```

### 4. Label Class

Create a [label.dart](https://github.com/ryanhoo95/flutter_i18n_from_api/blob/master/lib/language/label.dart) to serve as a data class of label.

```dart
class Label {
  final String key;
  final String value;

  Label({
    this.key,
    this.value,
  });

  factory Label.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    return Label(
      key: json['key'],
      value: json['value'],
    );
  }
}
```

### 5. Label Util

Create a [label_util.dart](https://github.com/ryanhoo95/flutter_i18n_from_api/blob/master/lib/language/label_util.dart) to save the raw label data into local file and retrive the list of Label objects based on the selected language.

\***modify the function getLabels(String languageCode) based on your json structure**

```dart
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'label.dart';

class LabelUtil {
  static LabelUtil _instance;

  LabelUtil._();

  static LabelUtil get instance {
    if (_instance == null) {
      _instance = LabelUtil._();
    }

    return _instance;
  }

  // write the label into file
  Future<File> writeLabel(String data) async {
    final file = await _labelFile;

    // Write the file.
    final completeFile = file.writeAsString(data);

    return completeFile;
  }

  // return list of decoded Label
  Future<List<Label>> getLabels(String languageCode) async {
    try {
      final file = await _labelFile;

      // Read the file.
      String contents = await file.readAsString();

      // decode the raw data
      final parsed = jsonDecode(contents);

      // retrieve the respective labels based on language code
      final parsedLabel = parsed['label'][languageCode];

      return parsedLabel.map<Label>((json) => Label.fromJson(json)).toList();
    } catch (e) {
      print(e);
      return List();
    }
  }

  // get document path
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  // get the label file
  static Future<File> get _labelFile async {
    final path = await _localPath;
    return File('$path/label.txt');
  }
}
```

### 5. App Language Notifier

Create a [app_language.dart](https://github.com/ryanhoo95/flutter_i18n_from_api/blob/master/lib/language/app_language.dart) which extending ChangeNotifier. The language codes used by the app are added here as reference.

```dart
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLanguage extends ChangeNotifier {
  Locale _appLocale = Locale(LANG_EN);

  static const String LANG_EN = 'en';
  static const String LANG_MS = 'ms';
  static const String LANG_ZH = 'zh';
  final String keyLanguageCode = 'language_code';
  static String currentLanguageCode = LANG_EN;

  Locale get appLocale => _appLocale ?? Locale(LANG_EN);

  // return the locale based on the language code stored in shared pref
  // return locale en by default
  Future<Locale> fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();

    if (prefs.get(keyLanguageCode) == null) {
      _appLocale = Locale(LANG_EN);
    } else {
      _appLocale = Locale(prefs.get(keyLanguageCode));
    }

    return _appLocale;
  }

  // return the language code stored in shared pref
  // return en by default
  Future<String> fetchLanguageCode() async {
    var prefs = await SharedPreferences.getInstance();

    if (prefs.get(keyLanguageCode) == null) {
      return LANG_EN;
    } else {
      currentLanguageCode = prefs.get(keyLanguageCode);
      return currentLanguageCode;
    }
  }

  // switch language and notify the app for updating the label
  void changeLanguage(String langCode) async {
    var prefs = await SharedPreferences.getInstance();

    _appLocale = Locale(langCode);
    await prefs.setString(keyLanguageCode, langCode);
    currentLanguageCode = langCode;
    notifyListeners();
  }
}
```

- fetchLocale() -> return the locale based on the language code stored in shared preference.
- fetchLanguageCode() -> return the language code stored in shared preference.
- changeLanguage(String langCode) -> called everytime user switches the app language. It will save the language code in shared preferences and then notify the app that language was changed and update the UI accordingly.

### 6. App Localizations

Create a [app_localization.dart](https://github.com/ryanhoo95/flutter_i18n_from_api/blob/master/lib/language/app_localization.dart) to return the label to UI based on the label key.

```dart
import 'package:flutter/material.dart';

import 'app_language.dart';
import 'label.dart';
import 'label_util.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  // Helper method to keep the code in the widgets concise
  // Localizations are accessed using an InheritedWidget "of" syntax
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  // Static member to have a simple access to the delegate from the MaterialApp
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  List<Label> _labels = List();

  Future<bool> load() async {
    LabelUtil labelUtil = LabelUtil.instance;
    _labels = await labelUtil.getLabels(AppLanguage.currentLanguageCode);

    return true;
  }

  // This method will be called from every widget which needs a localized text
  String translate(String key) {
    try {
      String value =
          _labels.firstWhere((item) => item.key == key, orElse: null)?.value;
      if (value.isEmpty) {
        return null;
      }
      return value;
    } catch (e) {
      return null;
    }
  }
}

// LocalizationsDelegate is a factory for a set of localized resources
// In this case, the localized strings will be gotten in an AppLocalizations object
class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  // This delegate instance will never change (it doesn't even have fields!)
  // It can provide a constant constructor.
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Include all of your supported language codes here
    return [AppLanguage.LANG_EN, AppLanguage.LANG_MS, AppLanguage.LANG_ZH]
        .contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // AppLocalizations class is where the JSON loading actually runs
    AppLocalizations localizations = new AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => true;
}
```

- load() -> called everytime when user switches app language. It will retrive list of Label objects from LabelUtil and save the list as the class variable.
- translate(String key) -> return the label value based on the label key. Normally used in Text widget to display the label.

### 7. Main

In [main.dart](https://github.com/ryanhoo95/flutter_i18n_from_api/blob/master/lib/main.dart):

1. We have to pass an instance AppLanguage object to MyApp widget.
2. Wrap MaterialApp widget with ChangeNotifierProvider of AppLanguage.
3. Add the supported locales to MaterialApp widget.
4. Add the localizations delegates to MaterialApp widget.
5. Supply the locale to MaterialApp widget with AppLanguage's locale from Consumer's model.

```dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_i18n_from_api/language/app_language.dart';
import 'package:tutorial_i18n_from_api/ui/splash_screen.dart';

import 'language/app_localization.dart';

void main() {
  runApp(MyApp(AppLanguage()));
}

class MyApp extends StatelessWidget {
  final AppLanguage _appLanguage;

  MyApp(this._appLanguage);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppLanguage>(
      create: (_) => _appLanguage,
      child: Consumer<AppLanguage>(builder: (context, model, child) {
        return MaterialApp(
          title: 'Flutter i18n',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          supportedLocales: [
            Locale(AppLanguage.LANG_EN),
            Locale(AppLanguage.LANG_MS),
            Locale(AppLanguage.LANG_ZH),
          ],
          localizationsDelegates: [
            AppLocalizations.delegate,
            // built-in localization of basic text for Material Widgets
            GlobalMaterialLocalizations.delegate,
            // built-in localization for text-direction LTR/RTL
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate
          ],
          locale: model.appLocale,
          home: SplashScreen(),
        );
      }),
    );
  }
}
```

### 8. Splash Screen

In [splash_screen.dart](https://github.com/ryanhoo95/flutter_i18n_from_api/blob/master/lib/ui/splash_screen.dart),

1. We mock the API call by calling \_getLabel() in initState().
2. The raw json data is then stored in local file.
3. Retrieve the saved language code from shared preference.
4. Change the app language.
5. Navigate to home page.

```dart
@override
void initState() {
  super.initState();

  _getLabel();
}

void _getLabel() {
  // simulate api call to retrieve the label from backend
  String rawData = MockApi.sampleJson;

  // wait one seconds (simulate network traffic)
  Future.delayed(Duration(seconds: 2), () async {
    await LabelUtil.instance.writeLabel(rawData);

    // load language
    AppLanguage appLanguage = Provider.of<AppLanguage>(
      context,
      listen: false,
    );

    String languageCodeFromSharedPref = await appLanguage.fetchLanguageCode();
    appLanguage.changeLanguage(languageCodeFromSharedPref);

    // go to home page
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
      (route) => false,
    );
  });
}
```

### 9. Home Page

In [home_page.dart](https://github.com/ryanhoo95/flutter_i18n_from_api/blob/master/lib/ui/home_page.dart),

1. Declare a variable of type AppLanguage and initialize it from Provider.

   _Timer.run() was used to ensure the initialization is done after the widget is completely inited._

```dart
AppLanguage _appLanguage;

@override
void initState() {
  super.initState();

  Timer.run(() {
    _appLanguage = Provider.of<AppLanguage>(
      context,
      listen: false,
    );
  });
}
```

2. Add Text widget to display the label by using the label key.

   _Since translate(String key) might return null value, so we have to consider null-safety coding._

```dart
Text(
  AppLocalizations.of(context).translate(Greeting_Message) ??
      'Empty',
),
```

3. Supply the locale from AppLanguage to Flutter's date picker.

```dart
showDatePicker(
  context: context,
  initialDate: DateTime.now(),
  firstDate: DateTime(DateTime.now().year - 99),
  lastDate: DateTime(DateTime.now().year + 99),
  locale: _appLanguage.appLocale,
);
```

4. Add button to switch the app language when user taps on it.

```dart
MaterialButton(
  color: Colors.blue,
  onPressed: () {
    _appLanguage.changeLanguage(AppLanguage.LANG_EN);
  },
  child: Text(
    'English',
    style: TextStyle(
      color: Colors.white,
    ),
  ),
),
MaterialButton(
  color: Colors.blue,
  onPressed: () {
    _appLanguage.changeLanguage(AppLanguage.LANG_MS);
  },
  child: Text(
    'Melayu',
    style: TextStyle(
      color: Colors.white,
    ),
  ),
),
MaterialButton(
  color: Colors.blue,
  onPressed: () {
    _appLanguage.changeLanguage(AppLanguage.LANG_ZH);
  },
  child: Text(
    '中文',
    style: TextStyle(
      color: Colors.white,
    ),
  ),
),
```

## That's all. Thank you..
