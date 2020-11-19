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
