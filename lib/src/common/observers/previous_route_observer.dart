import 'package:flutter/material.dart';

class PreviousRouteObserver extends NavigatorObserver {
  static Route<dynamic>? value;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    PreviousRouteObserver.value = previousRoute;
  }
}
