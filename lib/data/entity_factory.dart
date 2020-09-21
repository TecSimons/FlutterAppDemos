import 'package:flutter_app/Item/net_gridview_entity.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    } else  if (T.toString() == "NetGridViewEntity") {
      return NetGridViewEntity.fromJson(json) as T;
    } else {
      return null;
    }
  }
}