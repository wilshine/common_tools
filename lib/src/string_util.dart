import 'dart:math';



class StringUtil {
  /// 有时候Text中有空格的时候，使用overflow会从中间截断，对字符串处理下
  static String breakWord(String word) {
    if (word.isEmpty) {
      return word;
    }
    String breakWord = '';
    for (var element in word.runes) {
      var char = String.fromCharCode(element);
      breakWord += char;
      breakWord += '\u200B';
    }
    return breakWord;
  }

  static bool isNullOrEmpty(String? str) {
    return str == null || str.isEmpty;
  }

  static const String _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  static String getRandomString(int length) {
    Random _rnd = Random();
    return String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

}
