//setting
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/custom_sliver_header_usage.dart';
import 'package:flutter_app/pages/image_preview.dart';
import 'package:flutter_app/pages/login_page.dart';

import '../pages/home_page.dart';


Handler homeHandler =
    Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return HomePage();
});

Handler loginHandler =
    Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return LoginPage();
});
Handler imagePreviewHandler =
Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
//  print('handleData111====>$params');
  String data = params['data']?.first;
  return ImagePreview(data: data);
});
Handler sliverHeader =
Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
return CustomSliverHeaderDemo();
});


