/// 校验工具
class ValidatorUtil {
  static const String kEMAILPATTERN =
      "^([a-z0-9A-Z]+[-|_|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,6}\$";

  static bool isEmailSameWithServer(String email) {
    if (email.isEmpty) return false;
    bool result = RegExp(kEMAILPATTERN).hasMatch(email);
    return result;
  }

  static const String kEMAILPATTERN1 = "^([a-z0-9A-Z]+[-|_|\\.]?)+[a-z0-9A-Z]";
  static const String kEMAILPATTERN2 = "@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,6}\$";
  static const String kNotEmailLetterPattern = '[^a-z0-9A-Z_\\-\\.@]';
  static bool isEmailSameWithServerEx(String? email) {
    if (email == null) return false;
    if (email.isEmpty) return false;
    if (!email.contains('@')) return false;
    if (!email.contains('.')) return false;
    if (email.contains('__') || email.contains('_-') || email.contains('_.')) return false;
    if (email.contains('..') || email.contains('.-') || email.contains('._')) return false;
    if (email.contains('--') || email.contains('-.') || email.contains('-_')) return false;
    // contains not email letters???
    if (RegExp(kNotEmailLetterPattern).hasMatch(email)) {
      return false;
    }
    bool regex1 = RegExp(kEMAILPATTERN2).hasMatch(email);
    bool regex2 = RegExp(kEMAILPATTERN2).hasMatch(email);
    return regex1 && regex2;
  }

  static bool isEmail(String email) {
    String regexEmail = "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$";
    if (email.isEmpty) return false;
    return RegExp(regexEmail).hasMatch(email);
  }

  static bool isAllNumber(String string) {
    String regex = "^\\d+\$";
    if (string.isEmpty) return false;
    return RegExp(regex).hasMatch(string);
  }

  static bool isAllNumberSAndFirstIsMoreThanZero(String string) {
    String regex = "^[1-9][0-9]*\$";
    if (string.isEmpty) return false;
    return RegExp(regex).hasMatch(string);
  }

  static bool isAllNumberLetter(String string) {
    String regex = "^[0-9a-zA-Z]*\$";
    if (string.isEmpty) return false;
    return RegExp(regex).hasMatch(string);
  }

  static bool isAllNumberLetterSpace(String string) {
    String regex = "^[0-9a-zA-Z ]*\$";
    if (string.isEmpty) return false;
    return RegExp(regex).hasMatch(string);
  }

  static bool isBase64Character(String one) {
    if (one.isEmpty) return false;
    // A-Z，a-z，0-9，+，/，=
    return "0-9a-zA-Z/=+".contains(one);
  }

}
