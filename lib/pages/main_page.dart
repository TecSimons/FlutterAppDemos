import 'package:fluintl/fluintl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/application_bloc.dart';
import 'package:flutter_app/app/bloc_provider.dart';
import 'package:flutter_app/const/_const.dart';
import 'package:flutter_app/pages/net_grid_view.dart';
import 'package:flutter_app/pages/pull_grid_view.dart';
import 'package:flutter_app/pages/second_view.dart';
import 'package:flutter_app/res/strings.dart';
import 'package:flutter_app/utils/spHelper.dart';

import 'home_view.dart';


class _Page {
  final String labelId;
  final String label;

  _Page(this.labelId,this.label);
}

final List<_Page> _allPages = <_Page>[
  _Page(Ids.titleHome,"首页"),
  _Page(Ids.titleRepos,"项目"),
  _Page(Ids.titleEvents,"动态"),
  _Page(Ids.titleSystem,"体系"),

];

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPage createState() => _MainPage();
}



class _MainPage extends State<MainPage> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    _initListener();
//    print("_initListener"+ IntlUtil.getString(context, Ids.titleHome));
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


  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
        length: _allPages.length,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: themeColor,
            centerTitle: true,
            title: TabLayout(),
            actions: <Widget>[
            ],
          ),
          body: TabBarViewLayout(),

        ));
  }


  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class TabLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TabBar(
      isScrollable: true,
      unselectedLabelStyle: TextStyle(
          fontSize: 16,
          color: Color(0x22aaaaaa)

      ),
      labelStyle: TextStyle(
          fontSize: 20,
          color: Color(0xffffff),
          fontWeight: FontWeight.bold,
      ),
//      labelPadding: EdgeInsets.all(12.0),
      indicatorSize: TabBarIndicatorSize.label,
      indicatorColor: Colors.transparent,
      labelPadding: EdgeInsets.only(left:20,right:20),

      tabs: _allPages
          .map((_Page page) =>
//              Tab(text: page.label))
              Tab(text: IntlUtil.getString(context, page.labelId)))
          .toList(),
    );
  }
}

class TabBarViewLayout extends StatelessWidget {
  Widget buildTabView(BuildContext context, _Page page) {
    String labelId = page.labelId;
    switch (labelId) {
      case Ids.titleHome:
        return HomeView();
        break;
      case Ids.titleRepos:
        return PullGridView();
        break;
      case Ids.titleEvents:
        return NetGridPage();
        break;
      case Ids.titleSystem:
        return SecondScreen();
        break;
      default:
        return Container();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
        children: _allPages.map((_Page page) {
      return buildTabView(context, page);
    }).toList());
  }
}
