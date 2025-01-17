

library google_transl;

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
// import './tokens/google_token_gen.dart';
import './langs/language.dart';

part './model/translation.dart';

///
/// This library is a Dart implementation of Google Translate API
///
/// [author] Gabriel N. Pacheco.
///
class GoogleTranslator {
  var _baseUrl = 'translate.googleapis.com'; // faster than translate.google.com
  final _path = '/language/translate/v2';
  final String _tokenProvider = 'AIzaSyDiGS17oJ3rHMN04Ct6LluBsCVnMwdSi5M';
  final _languageList = LanguageList();
  final ClientType client;

  GoogleTranslator({this.client = ClientType.siteGT});

  /// Translates texts from specified language to another
  Future<Translation> translate(String sourceText,
      {String to = 'en'}) async {
    for (var each in [to]) {
      if (!LanguageList.contains(each)) {
        throw LanguageNotSupportedException(each);
      }
    }

    final parameters = {
//       'client': client == ClientType.siteGT ? 't' : 'gtx',
      'target': to,
//       'hl': to,
//       'dt': '',
      'ie': 'UTF-8',
      'oe': 'UTF-8',
//       'otf': '',
//       'ssel': '',
//       'tsel': '',
//       'kc': '',
      'key': _tokenProvider,
      'q': sourceText
    };

    var url = Uri.https(_baseUrl, _path, parameters);
    final data = await http.get(url);

    if (data.statusCode != 200) {
      throw http.ClientException('Error ${data.statusCode}: ${data.body}', url);
    }

    final body = json.decode(data.body);
    final sb = StringBuffer();

//     for (var c = 0; c < jsonData[0]; c++) {
//       sb.write(jsonData[0][c][0]);
//     }

//     if (from == 'auto' && from != to) {
//       from = jsonData[2] ?? from;
//       if (from == to) {
//         from = 'auto';
//       }
//     }

    final translated = sb.toString();
    return _Translation(
      translated,
      source: sourceText,
//       sourceLanguage: _languageList[from],
      targetLanguage: _languageList[to],
    );
  }

  /// Translates and prints directly
  void translateAndPrint(String text,
      {String to = 'en'}) {
    translate(text, to: to).then(print);
  }

  /// Sets base URL for countries that default URL doesn't work
  void set baseUrl(String url) => _baseUrl = url;
}

// enum ClientType {
//   siteGT, // t
//   extensionGT, // gtx (blocking ip sometimes)
// }
//   final _path = '';
//   final String _tokenProvider = '';
 
