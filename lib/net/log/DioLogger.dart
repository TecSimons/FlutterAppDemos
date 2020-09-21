import 'package:dio/dio.dart';
import 'package:flutter_app/const/string_const.dart';
import 'package:flutter_app/utils/SpUtils.dart';
import 'Log.dart';


class DioLogger{

  DioLogger(){
    Log.init();
  }

  onSend(String tag,Options options)async{
    Map<String,dynamic> headers = new Map();
    headers['Cookie'] = await SpUtils.get(StringConst.login_cookie);
    options.headers = headers;
    Log.info('$tag - Request Path : [${options.method}] ${options.baseUrl}${options.path.toString()}');
  }

  onSuccess(String tag, Response response){
    Log.info('$tag - Response Path : [${response.request.method}] ${response.request.baseUrl}${response.request.path} Request Data : ${response.request.data.toString()}');
  }

  onError(String tag, DioError error){
    Log.info('$tag - Response data : ${error.response.data.toString()}');
  }
}