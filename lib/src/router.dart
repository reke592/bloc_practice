import 'package:bloc_practice/src/common/observers/previous_route_observer.dart';
import 'package:bloc_practice/src/tickets/tickets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final rootNavigator = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: rootNavigator,
  observers: [PreviousRouteObserver()],
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => Scaffold(
        body: Center(
          child: TextButton(
            child: const Text('Tickets'),
            onPressed: () {
              context.goNamed('ticket list');
            },
          ),
        ),
      ),
    ),
    ticketsRouteConfiguration(rootNavigator: rootNavigator),
  ],
);
