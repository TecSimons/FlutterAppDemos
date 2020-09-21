import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/router/router_handler.dart';

// 在routes.dart文件中配置路由，这里需要注意的事首页一定要用“/”配置，其它页无所谓
class Routes {
  static Router router;

  static String root = '/';
  static String home = '/home';
  static String login = '/login';
  static String imagePreview = '/imagePreview';
  static String sliverView = '/sliverHeader';

  static void configureRouters(Router router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      print('ERROR====>>>>ROUTE WAS NOT FOUND!!!');
      return;
    });

    router.define(home, handler: homeHandler); //首页界面
    router.define(login, handler: loginHandler); //登录界面
    router.define(imagePreview, handler: imagePreviewHandler); //登录界面
    router.define(sliverView, handler: sliverHeader); //登录界面

  }

  // 对参数进行encode，解决参数中有特殊字符，影响fluro路由匹配
  static Future navigateTo(BuildContext context, String path,
      {Map<String, dynamic> params,
      TransitionType transition = TransitionType.native,
      bool clearStack = false}) {
    String query = "";
    if (params != null) {
      int index = 0;
      for (var key in params.keys) {
        var value = Uri.encodeComponent(params[key]);
        if (index == 0) {
          query = "?";
        } else {
          query = query + "\&";
        }
        query += "$key=$value";
        index++;
      }
    }
    print('navigatorTo传递的参数:$query');
    path += query;
    return router.navigateTo(context, path,
        transition: transition, clearStack: clearStack);
  }

  //关闭当前页面
  static pop(BuildContext context) {
    router.pop(context);
  }


}
