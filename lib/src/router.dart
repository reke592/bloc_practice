import 'dart:convert';

import 'package:bloc_practice/src/common/message_dialogs.dart';
import 'package:bloc_practice/src/common/observers/previous_route_observer.dart';
import 'package:bloc_practice/src/tickets/tickets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';

final rootNavigator = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: rootNavigator,
  observers: [PreviousRouteObserver()],
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => Scaffold(
        body: Center(
          child: FutureBuilder(
              future: rootBundle.loadStructuredData<List<Map<String, dynamic>>>(
                'resource/meta/practice.json',
                (value) async => List<Map<String, dynamic>>.from(
                  jsonDecode(value),
                ),
              ),
              builder: (context, snapshot) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var meta in snapshot.data ?? [])
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              context.goNamed(meta['initialRouteName']);
                            },
                            icon: const FaIcon(FontAwesomeIcons.play),
                            label: Text(meta['title']),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: () {
                              MessageDialogs.confirm(
                                context,
                                message:
                                    'You are about to open an external URL:'
                                    '\n${meta['repositoryUrl']}'
                                    '\n\nWould you like to continue?',
                              ).then((value) {
                                if (value == true) {
                                  launchUrlString(meta['repositoryUrl']);
                                }
                              });
                            },
                            icon: const FaIcon(FontAwesomeIcons.github),
                            label: const Text('Repository'),
                          )
                        ],
                      ),
                  ],
                );
              }),
        ),
      ),
    ),
    ticketsRouteConfiguration(rootNavigator: rootNavigator),
  ],
);
