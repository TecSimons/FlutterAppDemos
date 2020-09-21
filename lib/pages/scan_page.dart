import 'dart:async';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/const/_const.dart';
import 'package:flutter_app/router/routes.dart';
import 'package:flutter_app/utils/ToastUtil.dart';
import 'package:flutter_app/utils/navigator_util.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'base/base_page.dart';


//class QrCodeScan extends StatefulWidget {
//  @override
//  _QrCodeScanState createState() => _QrCodeScanState();
//}
//
//class _QrCodeScanState extends State<QrCodeScan> with AutomaticKeepAliveClientMixin,WidgetsBindingObserver{
// ignore: must_be_immutable

class QrCodeScan extends BasePage{
  @override
  BasePageState<BasePage> getState() {
    // TODO: implement getState
    return _QrCodeScanState();
  }
  
}

class _QrCodeScanState extends BasePageState<QrCodeScan> {

  QRViewController controller;

  String _flash_State  = "打开闪光灯";
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  initState() {
    super.initState();
  }

  @override
  void onResume() {
    if(controller!=null) {
       controller.resumeCamera();
    }
  }

  @override
  void onPause() {
  }


  @override
  void onCreate() {
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget buildWidget(BuildContext context) {

    return  Scaffold(
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: themeColor,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: 280,
            ),
          ),
          Container(
              child: Column(
                children: [
                  Stack(children: [
                    Container(
                      height: 80,
                      color: themeColor,
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(top: 30),
                      child: Text(
                        "扫一扫",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 80,
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(top: 30,left: 5,right: 20),
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Image.asset("assets/images/back.png",width: 24,height: 24),
                            onPressed:() {backReturn(context);},
                          ),
                          GestureDetector(
                            onTap: () { openFlash();},
                            child:Text(
                              _flash_State,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFFFFFFFF),
                            ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ],
              )),
        ],

      ),
    );
  }


  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.resumeCamera();
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();
      setState(() {
//        qrText = scanData;
        ToastUtil.showToast(scanData);
        if(scanData.substring(0,4)=="http"){
//          NavigatorUtil.pushWeb(context, title: "", url: scanData);
//          Routes.navigateTo(context, '/sliverHeader');
          skipToPageD(scanData);
        }

      });

//      Future.delayed(Duration(milliseconds: 1500), () {
//        controller.resumeCamera();
//      });
    });
  }

  void skipToPageD(String scanData) async {
    final result = await  NavigatorUtil.pushWeb(context, url: scanData);
//    final result = await  Routes.navigateTo(context, '/sliverHeader');

    String p = result as String;

    if(controller!=null) {
      controller.resumeCamera();
    }
  }


  void backReturn(BuildContext context) {
      Navigator.pop(context);
  }

  void openFlash() {
    if(controller!=null){
      controller.toggleFlash();
      if(_flash_State=="打开闪光灯") {
        setState(() {
          _flash_State="关闭闪光灯";
        });
      }else{
        setState(() {
          _flash_State="打开闪光灯";
        });
      }
    }
  }


}