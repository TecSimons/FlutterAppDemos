import "package:flutter/material.dart";
import 'package:flutter_app/app/application_bloc.dart';
import 'package:flutter_app/app/bloc_provider.dart';
import 'package:flutter_app/pages/my_page.dart';
import 'package:flutter_app/pages/second_view.dart';
import 'package:flutter_app/utils/spHelper.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../const/color_const.dart';
import '../const/string_const.dart';
import 'main_page.dart';
import 'main_view.dart';
import 'pull_list_view.dart';

class HomePage extends StatefulWidget {
  @override
  _MyHomePage createState() => _MyHomePage();
}

class _MyHomePage extends State<HomePage> {
  int _selectedIndex = 0;
  List _pages = List();
  PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
    _pages.add(MainView());
    _pages.add(MainPage());
    _pages.add(PullListView());
    _pages.add(MyPage());
    _initListener();
  }

  void _initListener() {
    final ApplicationBloc bloc = BlocProvider.of<ApplicationBloc>(context);
    bloc.appEventStream.listen((value) {
      _loadLocale();
    });
  }

  void _loadLocale() {
    String _colorKey = SpHelper.getThemeColor();
    if (themeColorMap[_colorKey] != null) {
      setState(() {
        themeColor = themeColorMap[_colorKey];
      });
    }
  }

  var _navigationBars = [
    BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text(StringConst.home_tab),
        backgroundColor: Colors.white),
    BottomNavigationBarItem(
        icon: Icon(Icons.send),
        title: Text(StringConst.find_tab),
        backgroundColor: Colors.white),
    BottomNavigationBarItem(
        icon: Icon(Icons.album),
        title: Text(StringConst.contact_tab),
        backgroundColor: Colors.white),
    BottomNavigationBarItem(
        icon: Icon(Icons.person),
        title: Text(StringConst.mine_tab),
        backgroundColor: Colors.white),
  ];




  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false, //输入法顶布局
//      appBar: AppBar(
//        centerTitle: true,
//        title: Text("wanandroid"),
//        actions: <Widget>[
//          IconButton(icon: Icon(Icons.search),
//              onPressed: () => _openSearch())
//        ],
//      ),
      body: PageView.builder(
        itemBuilder: (context, index) => _pages[index],
        // physics: NeverScrollableScrollPhysics(),// 禁止左右滑动
        itemCount: _pages.length,
        onPageChanged: _onPageChanged,
        controller: _controller,
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(
          brightness: Brightness.light,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          items: _navigationBars,
          currentIndex: _selectedIndex,
//        unselectedItemColor: DARK_COLOR,
//        selectedItemColor:themeColor ,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          fixedColor: themeColor,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          onTap: _onTap,
        ),
      ),
    );
  }

  _openSearch() {
//    Navigator.of(context).push(new MaterialPageRoute
//      (builder: (context) => SearchPage()));
  }

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _controller.jumpToPage(index);
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


}
