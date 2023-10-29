import 'dart:ui';

import 'package:bloc_practice/src/router.dart';
import 'package:bloc_practice/src/stylesheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/common/observers/app_observer.dart';

class CustomScroll extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => <PointerDeviceKind>{
        PointerDeviceKind.touch,
        PointerDeviceKind.stylus,
        PointerDeviceKind.invertedStylus,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.mouse,
        // The VoiceAccess sends pointer events with unknown type when scrolling
        // scrollables.
        PointerDeviceKind.unknown,
      };
}

void main() {
  Bloc.observer = AppObserver();
  runApp(MyApp(
    routerConfig: router,
  ));
}

class MyApp extends StatelessWidget {
  final RouterConfig<Object> routerConfig;
  const MyApp({
    super.key,
    required this.routerConfig,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Bloc Practice',
      theme: Stylesheet.mainTheme,
      routerConfig: routerConfig,
      scrollBehavior: CustomScroll(),
    );
  }
}
