import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_i18n_from_api/api/mock_api.dart';
import 'package:tutorial_i18n_from_api/language/app_language.dart';
import 'package:tutorial_i18n_from_api/language/label_util.dart';
import 'package:tutorial_i18n_from_api/ui/home_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/flutter.png',
                width: 150,
              ),
              SizedBox(
                height: 50.0,
              ),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
