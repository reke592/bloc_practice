import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    log('created $bloc');
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    log('closed: $bloc');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log('$bloc ${change.nextState}');
  }
}
