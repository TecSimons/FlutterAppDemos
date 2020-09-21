

import 'dart:io';

import 'package:base_library/base_library.dart';
import 'package:fluintl/fluintl.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/const/string_const.dart';
import 'package:flutter_app/pages/home_page.dart';
import 'package:flutter_app/pages/login_page.dart';
import 'package:flutter_app/res/index.dart';
import 'package:flutter_app/router/routes.dart';
import 'package:flutter_app/utils/spHelper.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app/application_bloc.dart';
import 'app/bloc_provider.dart';
import 'app/global.dart';
import 'config/Config.dart';
import 'const/color_const.dart';
import 'model/models.dart';




FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
void main() {
  /**
   * 在每一次启动时进行判断，这个过程必须是同步的，
   * 但flutter提供的shared_preferences和package_info却都是异步的,
   * 这就导致获取值及路由跳转不同步问题。
   * 解决方法：
   *  在main入口方法中先调用初始化方法，再去调用runApp方法，
   *  这样就可以将 “异步” 操作 转化成 “同步” 操作
   */
//  WidgetsFlutterBinding.ensureInitialized(); // Flutter 1.7.8+版本必须加，否则报错
//
//  if (Platform.isAndroid) {
//    // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
//    // 底色透明是否生效与Android版本有关，版本过低设置无效
//    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
//      statusBarColor: Colors.transparent, //全局设置透明
//      // statusBarIconBrightness: Brightness.light
//      //light:黑色图标  dark:白色图标
//    );
//    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
//
//  }


  flutterLocalNotificationsPlugin=new FlutterLocalNotificationsPlugin();
  Global.init(() {
    runApp(BlocProvider<ApplicationBloc>(
      bloc: ApplicationBloc(),
      child: BlocProvider(child: MyApp()),
    ));
  });
//  realRunApp();
}



void realRunApp() async {
  // await SpHelper.getInstance();
  await SpHelper.getInstance();
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _firstKey;

  Locale _locale;



  @override
  void initState() {
    super.initState();
    setInitDir(initStorageDir: true);
    setLocalizedValues(localizedValues);
    _loadLocale();
    _initListener();

  }



  void _initListener() {
    final ApplicationBloc bloc = BlocProvider.of<ApplicationBloc>(context);
    bloc.appEventStream.listen((value) {
      _loadLocale();
    });
  }

  void _loadLocale() {

    setState(() {
      LanguageModel model =
      SpUtil.getObj(StringConst.KEY_LANGUAGE, (v) => LanguageModel.fromJson(v));
      if (model != null) {
        _locale = new Locale(model.languageCode, model.countryCode);
      } else {
        _locale = null;
      }

      //    Log.info("themeColor=="+themeColor.value.toString());
      String _colorKey = SpHelper.getThemeColor();
      if (themeColorMap[_colorKey] != null) {
        themeColor = themeColorMap[_colorKey];
      }


    });

  }


  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {


    // 配置路由
    final router = Router();
    Routes.configureRouters(router);
    Routes.router = router;


    //是否第一次登录，是：显示引导页guide_page；否：显示home_page
    _firstKey = SpHelper.getBool(Config.KEY_IS_LOGIN, defValue: true);
        return MaterialApp(
          debugShowCheckedModeBanner: false, //关闭banner上的Debug标识
          onGenerateRoute: Routes.router.generator,
          theme: (Theme.of(context).copyWith(canvasColor: Colors.transparent)),
          home: _firstKey ? HomePage() : LoginPage(),
          locale: _locale,

            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              CustomLocalizations.delegate, //设置本地化代理
              FallbackCupertinoLocalisationsDelegate(), //加入这个, 上面三个是我用来国际化的
            ],
            supportedLocales: CustomLocalizations.supportedLocales,//设置支持本地化语言集合

        );

  }

}

class FallbackCupertinoLocalisationsDelegate extends LocalizationsDelegate<CupertinoLocalizations> {

  const FallbackCupertinoLocalisationsDelegate();

  @override

  bool isSupported(Locale locale) => true;

  @override

  Future<CupertinoLocalizations> load(Locale locale) =>

      DefaultCupertinoLocalizations.load(locale);

  @override

  bool shouldReload(FallbackCupertinoLocalisationsDelegate old) => false;

}




//void main() => runApp(HomePage());

