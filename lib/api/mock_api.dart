class MockApi {
  static String get sampleJson {
    return '''
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
    ''';
  }
}
