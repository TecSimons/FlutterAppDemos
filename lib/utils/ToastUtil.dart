import 'package:flutter/material.dart';
import 'package:flutter_app/const/color_const.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil {


  static void showToast(titles) {
    Fluttertoast.showToast(
        msg: titles,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: BLUE_DEEP,
        textColor: WHITE);
  }

  static void showDialogs(BuildContext context,String titile, String content) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(titile),
            content: Text(content),
            actions: [
              FlatButton(
                child: Text("取消"),
                textColor: Colors.grey,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("确定"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }


  static void showSnackBar(BuildContext context, String msg) {
    Scaffold.of(context).showSnackBar(
      SnackBar(content: Text("$msg",textAlign: TextAlign.left,style: TextStyle(fontSize: 15,color: Colors.white),),
        backgroundColor: themeColor,
        duration: Duration(milliseconds: 1800),
//        shape: CircleBorder(
//          side: BorderSide(
//            width: 2,
//            color: Colors.blue,
//            style: BorderStyle.solid,
//          ),
        ),

    );
  }

}


