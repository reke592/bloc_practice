import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

typedef RouteGuard = FutureOr<String?> Function(
  BuildContext context,
  GoRouterState state,
);
