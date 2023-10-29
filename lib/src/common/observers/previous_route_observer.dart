import 'package:flutter/material.dart';

class PreviousRouteObserver extends NavigatorObserver {
  static Route<dynamic>? value;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    PreviousRouteObserver.value = previousRoute;
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // print(previousRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // print(previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    // print(oldRoute);
  }
}
