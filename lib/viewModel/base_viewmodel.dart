import 'dart:async';

import 'package:flutter_app/net/api/ApiRepository.dart';
import 'package:rxdart/rxdart.dart';

abstract class BaseViewModel{
  CompositeSubscription subscriptions;
  ApiRepository repository;
  StreamSubscription subscription;

  BaseViewModel(){
    repository = new ApiRepository();
    subscriptions = CompositeSubscription();

  }

  dispose(){
    subscriptions.clear();
  }

}