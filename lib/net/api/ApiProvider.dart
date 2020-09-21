
import 'package:dio/dio.dart';
import 'package:flutter_app/model/groom_response.dart';
import 'package:flutter_app/net/log/DioLogger.dart';


class ApiProvider {
  static const String _baseUrl = "http://www.wanandroid.com";
  static const String _homeArticleUrl = "/article/list/%d/json";
  static const String _homeFindUrl = "/tree/json";
  static const String _findDetailUrl = "/article/list/%d/json?cid=";
  static const String _bannerUrl = "/banner/json";
  static const String _groomUrl = "/hotkey/json";
  static const String _searchUrl = "/article/query/%d/json";
  static const String _loginUrl = "/user/login";
  static const String _registerUrl = "/user/register";
  static const String _logoutUrl = "/user/logout/json";

  //收藏文章
  static const String _collectUrl = "/lg/collect/%d/json";

  //收藏的文章列表
  static const String _collectList = "/lg/collect/list/%d/json";

  //收藏页面取消收藏
  static const String _unCollectUrl = "/lg/uncollect/%d/json";

  static const String TAG = "dio========";
  static const String _cookie_tag = "set-cookie";

  Dio _dio;

  ApiProvider() {
    Options options = new Options(
      baseUrl: _baseUrl,
    );

    _dio = Dio(options);

    Response response;

    DioLogger dioLogger = new DioLogger();

    _dio.interceptor.request.onSend = (Options options) {
      dioLogger.onSend(TAG, options);
      return options;
    };

    _dio.interceptor.response.onSuccess = (Response response) {
      dioLogger.onSuccess(TAG, response);
      return response;
    };

    _dio.interceptor.response.onError = (DioError error) {
      dioLogger.onError(TAG, error);
      return error;
    };
  }


  //获取首页文章
//  getHomeArticle(int currentPage) async {
//    var response =
//    await _dio.get(sprintf(_homeArticleUrl, [currentPage]));
//    HomeArticle article = HomeArticle.fromJson(response.data);
//    return article;
//  }

  //获取首页发现页面
//  getHomeFind() async {
//    var response = await _dio.get(_homeFindUrl);
//    FindResponse findResponse = FindResponse.fromJson(response.data);
//    return findResponse;
//  }

  //获取发现页面详情文章列表
//  getFindDetailArticle(int currentPage, String cid) async {
//    var response = await _dio.get(sprintf(_findDetailUrl,
//        [currentPage]) + cid);
//    HomeArticle article = HomeArticle.fromJson(response.data);
//    return article;
//  }

  //获取轮播图
//  getBanner() async {
//    var response = await _dio.get(_bannerUrl);
//    BannerResponse banner = BannerResponse.fromJson(response.data);
//    return banner;
//  }

  //获取推荐列表
  getGroom() async {
    var response = await _dio.get(_groomUrl);
    GroomResponse groomResponse = GroomResponse.fromJson(response.data);
    return groomResponse;
  }

  //获取搜索结果
//  getSearchArticle(int currentPage, String keywords) async {
//    FormData data = new FormData();
//    data.add("k", keywords);
//    var response = await _dio.post(
//        sprintf(_searchUrl, [currentPage]), data: data);
//    HomeArticle article = HomeArticle.fromJson(response.data);
//    return article;
//  }

  //登录接口
//  doLogin(String userName, String password) async {
//    FormData data = new FormData();
//    data.add("username", userName);
//    data.add("password", password);
//    var response = await _dio.post(_loginUrl, data: data);
//    List<String> cookie = response.headers[_cookie_tag];
//    if (cookie != null && cookie.length > 0) {
//      SpUtils.save(StringConst.login_cookie, cookie);
//    }
//
//    UserResponse userResponse = UserResponse.fromJson(response.data);
//    return userResponse;
//  }

//  Future<bool> doLogout() async {
//    var response = await _dio.get(_logoutUrl);
//    bool result;
//    if (response.statusCode == 200) {
//      result = true;
//    } else {
//      result = false;
//    }
//    return result;
//  }

//  doRegister(String userName, String password) async {
//    FormData data = new FormData();
//    data.add("username", userName);
//    data.add("password", password);
//    data.add("repassword", password);
//    var response = await _dio.post(_registerUrl, data: data);
//    UserResponse userResponse = UserResponse.fromJson(response.data);
//    return userResponse;
//  }

  //单个文章的收藏
//  Future<bool> doCollect(int id) async {
//    var response = await _dio.post(sprintf(_collectUrl,
//        [id]));
//    if (response.data != null) {
//      return true;
//    } else {
//      return false;
//    }
//  }

  //获取收藏的列表
//  getCollectList(int currentPage) async {
//    var response = await _dio.get(sprintf(_collectList, [currentPage]));
//    HomeArticle article = HomeArticle.fromJson(response.data);
//    return article;
//  }

  //收藏页面取消收藏
//  Future<bool> unCollectArticle(int articleId, int originId) async {
//    FormData data = new FormData();
//    data.add("id", articleId);
//    data.add("originId", originId);
//    var response = await _dio.post(sprintf(_unCollectUrl, [articleId]),
//        data: data);
//    if (response.data != null) {
//      return true;
//    } else {
//      return false;
//    }
//  }
}
