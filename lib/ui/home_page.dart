import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_i18n_from_api/language/app_language.dart';
import 'package:tutorial_i18n_from_api/language/app_localization.dart';
import 'package:tutorial_i18n_from_api/language/label_key.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Flutter i18n',
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context).translate(Greeting_Message) ??
                      'Empty',
                ),
                Text(
                  AppLocalizations.of(context).translate(Greeting_Question) ??
                      'Empty',
                ),
                SizedBox(
                  height: 20.0,
                ),
                InkWell(
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(DateTime.now().year - 99),
                      lastDate: DateTime(DateTime.now().year + 99),
                      locale: _appLanguage.appLocale,
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey[400],
                      ),
                    ),
                    width: 200,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context).translate(Date_Hint) ??
                                'Empty',
                          ),
                        ),
                        Icon(
                          Icons.date_range,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
