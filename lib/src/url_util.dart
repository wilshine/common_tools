import 'package:url_launcher/url_launcher.dart';

class UrlUtil {
  /// 使用外部浏览器打开一个url
  static void openUrl(String url) async {
    // await canLaunchUrl(Uri.parse(url)) ? await launchUrl(Uri.parse(url)) : throw 'Could not launch $url';
  }

  /// 拨打电话
  static Future<void> callPhone(String phone) async {
    String url = 'tel:$phone';
    openUrl(url);
  }
}
