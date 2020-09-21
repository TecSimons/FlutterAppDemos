import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'file:///D:/flutter%20work/flutter_app/lib/pages/web_scaffold.dart';
import 'package:url_launcher/url_launcher.dart';

class NavigatorUtil {

  static Future pushWeb(BuildContext context,
      {String title, String titleId, String url, bool isHome: false}) {
    if (context != null && !ObjectUtil.isEmpty(url)) {
//    if (url.endsWith(".apk")) {
//      launchInBrowser(url, title: title ?? titleId);
//    } else {
      Navigator.push(
          context,
          new CupertinoPageRoute<void>(
              builder: (ctx) => new WebScaffold(
                    title: title,
                    titleId: titleId,
                    url: url,
                  )));
    }
  }


  static Future<Null> launchInBrowser(String url, {String title}) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }
}
