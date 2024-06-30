import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class OpenLink {
  static Future<void> open(String link) async {
    if (kIsWeb) {
      // Webの場合
      await launchUrl(Uri.parse(link), webOnlyWindowName: '_self');
    } else {
      // モバイルの場合
      final Uri url = Uri.parse(link);
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        return;
      }
    }
  }
}
