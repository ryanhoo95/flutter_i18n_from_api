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
