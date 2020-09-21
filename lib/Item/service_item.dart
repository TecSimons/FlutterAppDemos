import 'package:flutter/material.dart';
import 'package:flutter_app/net/log/Log.dart';
import 'package:flutter_app/pages/scan_page.dart';
import 'package:flutter_app/router/routes.dart';
import 'package:flutter_app/utils/ToastUtil.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


import '../main.dart';

class ServiceItem extends StatelessWidget {
  final ServiceItemViewModel data;


  ServiceItem({Key key, this.data}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){_showClick(context);},
     child: Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(bottom: 5),
      child: Column(
        mainAxisAlignment:  MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(child: this.data.icon),
//          IconButton(
//            icon: this.data.icon,
//          ),
          Text(
            this.data.title,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF333333),
            ),
          ),
        ],
      ),
    ),
    );
  }

  _showClick(BuildContext context) {
    if(data.title=="精选早餐"){
       Routes.navigateTo(context, '/sliverHeader');
    }else if(data.title=="包子") {
//      _showNotification();
    }else if(data.title=="炸鸡") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => QrCodeScan()),
      );
    }else{
//        ToastUtil.showToast(data.title);
        ToastUtil.showSnackBar(context, data.title);
    }
  }




}

class ServiceItemViewModel {
  /// 图标
  final Icon icon;

  /// 标题
  final String title;

  const ServiceItemViewModel({
    this.icon,
    this.title,
  });
}
