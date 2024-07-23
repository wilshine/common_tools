import 'package:intl/intl.dart' as intl;

/// 日期、时间工具类
class DateUtil {
  /// get Now Date Str.(yyyy-MM-dd HH:mm:ss)
  /// 获取现在日期字符串，默认是：yyyy-MM-dd HH:mm:ss
  static String getNowDateString() {
    return formatDate(DateTime.now());
  }

  /// 根据时间戳判断是否是今天
  static bool isToday(int milliseconds, {bool isUtc = false}) {
    if (milliseconds == 0) return false;
    DateTime old = DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: isUtc);
    DateTime now = isUtc ? DateTime.now().toUtc() : DateTime.now().toLocal();
    return old.year == now.year && old.month == now.month && old.day == now.day;
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date2.year == date1.year && date2.month == date1.month && date2.day == date1.day;
  }

  static bool isYesterday(DateTime date) {
    DateTime now = DateTime.now();
    DateTime yesterday = now.subtract(const Duration(days: 1));
    var millis = date.millisecondsSinceEpoch;
    return getStart(yesterday).millisecondsSinceEpoch <= millis && millis <= getOver(yesterday).millisecondsSinceEpoch;
  }

  static bool isThisWeek(DateTime date) {
    var millis = DateTime.now().millisecondsSinceEpoch;
    return getWeekStart(date).millisecondsSinceEpoch <= millis && millis <= getWeekOver(date).millisecondsSinceEpoch;
  }

  static DateTime getStart(DateTime d) {
    return DateTime(d.year, d.month, d.day);
  }

  static DateTime getOver(DateTime d) {
    return DateTime(d.year, d.month, d.day, 23, 59, 59, 999);
  }

  static DateTime getWeekStart(DateTime d) {
    // start from Monday. i.e 2019-10-07 00:00:00.000
    return getStart(d.subtract(Duration(days: d.weekday - 1)));
  }

  static DateTime getWeekOver(DateTime d) {
    // end with next Monday. i.e 2019-10-14 00:00:00.000 minus 1 millis second
    return getStart(d.add(Duration(days: DateTime.daysPerWeek - d.weekday + 1))).subtract(const Duration(milliseconds: 1));
  }

  /// 返回整点
  static DateTime getIntegralPoint(DateTime d) => DateTime(d.year, d.month, d.day, d.hour, 0);

  /// get DateTime By Milliseconds.
  /// 将毫秒时间转化为DateTime
  static DateTime getDateTimeByMs(int ms, {bool isUtc = false}) {
    return DateTime.fromMillisecondsSinceEpoch(ms, isUtc: isUtc);
  }

  static Map<int, String> monthMap = {
    1: 'Jan',
    2: 'Feb',
    3: 'Mar',
    4: 'Apr',
    5: 'May',
    6: 'Jun',
    7: 'Jul',
    8: 'Aug',
    9: 'Sep',
    10: 'Oct',
    11: 'Nov',
    12: 'Dec',
  };

  /// com format.
  static String _comFormat(int value, String format, String single, String full) {
    if (format.contains(single)) {
      if (format.contains(full)) {
        format = format.replaceAll(full, value < 10 ? '0$value' : value.toString());
      } else {
        format = format.replaceAll(single, value.toString());
      }
    }
    return format;
  }

  /// format date by DateTime.
  /// format 转换格式(已提供常用格式 DateFormats，可以自定义格式：'yyyy/MM/dd HH:mm:ss')
  static String formatDate(DateTime dateTime, {String? format}) {
    format = format ?? DateFormats.full;
    if (format.contains('yy')) {
      String year = dateTime.year.toString();
      if (format.contains('yyyy')) {
        format = format.replaceAll('yyyy', year);
      } else {
        format = format.replaceAll('yy', year.substring(year.length - 2, year.length));
      }
    }
    format = _comFormat(dateTime.month, format, 'M', 'MM');
    format = _comFormat(dateTime.day, format, 'd', 'dd');
    format = _comFormat(dateTime.hour, format, 'H', 'HH');
    format = _comFormat(dateTime.minute, format, 'm', 'mm');
    format = _comFormat(dateTime.second, format, 's', 'ss');
    format = _comFormat(dateTime.millisecond, format, 'S', 'SSS');
    return format;
  }

  /// 字符串格式转换成日期类
  static DateTime? parseStringTry(String date) {
    if (date.isEmpty) {
      return null;
    }
    try {
      return DateTime.parse(date);
    } catch (e, s) {
      throw Error.throwWithStackTrace('Parse date error for string:$date, $e', s);
    }
  }

  static DateTime parseString(String dateStr) {
    return DateTime.parse(dateStr);
  }

  /// 返回格式 'Nov.2021'
  static String getMonthYearDate(DateTime date) {
    return translate(date.toString(), pattern: 'MMM.yyyy');
  }

  /// 返回格式 'May081010102020'
  static String getMonthStampPrefixDate(DateTime date) {
    return translate(date.toString(), pattern: 'MMMddHHmmssyyyy');
  }

  /// 返回格式 '9 May, 2020'
  static String getDayMonthYearDate(DateTime date) {
    return getDayMonthYear(date.toString());
  }

  /// 返回格式 '9 May, 2020'
  static String getDayMonthYear(String date) {
    return translate(date, pattern: 'd MMM, yyyy');
  }

  /// 返回格式 '10:00'
  static String getHM(String date) {
    return translate(date, pattern: 'HH:mm');
  }

  /// 返回格式 '08 May, 2020 10:00'
  static String getDayMonthYearHM(String str) {
    return translate(str, pattern: 'd MMM, yyyy HH:mm');
  }

  /// 返回格式 '9 May, 2020 03:30:01'
  static String getDayMonthYearHMS(String str) {
    return translate(str, pattern: 'd MMM, yyyy HH:mm:ss');
  }

  /// INTL format
  static String translateDash(String date, {String? pattern}) {
    String str = translate(date, pattern: pattern);
    return str.isEmpty ? '-' : str;
  }

  static String translate(String date, {String? pattern}) {
    return formatString(date, pattern: pattern ??= 'd MMM, yyyy HH:mm');
  }

  static String formatString(String date, {String pattern = DateFormats.full}) {
    if (date.isEmpty) {
      return '';
    }
    try {
      DateTime dateTime = DateTime.parse(date);
      return format(dateTime, pattern: pattern);
    } catch (e, s) {
      throw Error.throwWithStackTrace('Parse date error $date: $e', s);
    }
  }

  static String format(DateTime date, {String pattern = DateFormats.full}) {
    try {
      return intl.DateFormat(pattern).format(date);
    } catch (e, s) {
      throw Error.throwWithStackTrace('intl parse date error: $date, $e', s);
    }
  }

}

class DateFormats {
  /// 一些常用格式参照。如果下面格式不够，你可以自定义
  /// 格式要求
  static const String whole = 'yyyy-MM-dd HH:mm:ss.SSS';
  static const String full = 'yyyy-MM-dd HH:mm:ss';
  static const String kYMDHM = 'yyyy-MM-dd HH:mm';
  static const String kYMD = 'yyyy-MM-dd';
  static const String kYM = 'yyyy-MM';
  static const String kMD = 'MM-dd';
  static const String kMDHM = 'MM-dd HH:mm';
  static const String kHMS = 'HH:mm:ss';
  static const String kHM = 'HH:mm';
  static const String kDMDOTY = 'd MMM, yyyy';

  static const String cnFULL = 'yyyy年MM月dd日 HH时mm分ss秒';
  static const String cnYMDHM = 'yyyy年MM月dd日 HH时mm分';
  static const String cnYMD = 'yyyy年MM月dd日';
  static const String cnYM = 'yyyy年MM月';
  static const String cnMD = 'MM月dd日';
  static const String cnMDHM = 'MM月dd日 HH时mm分';
  static const String cnHMS = 'HH时mm分ss秒';
  static const String cnHM = 'HH时mm分';

  static const String kParamFULL = 'yyyy/MM/dd HH:mm:ss';
  static const String kParamYMDHM = 'yyyy/MM/dd HH:mm';
  static const String kParamDMYHM = 'dd/MM/yyyy HH:mm';
  static const String kParamYMD = "yyyy/MM/dd";
  static const String kParamDMY = 'dd/MM/yyyy';
  static const String kParamYM = 'yyyy/MM';
  static const String kParamMD = 'MM/dd';
  static const String kParamMDHM = 'MM/dd HH:mm';

  static const String kDMYHM = 'dd-MM-yyyy HH:mm';
}
