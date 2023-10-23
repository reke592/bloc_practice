import 'package:bloc_practice/src/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/common/utils/app_observer.dart';

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: routerConfig,
    );
  }
}
