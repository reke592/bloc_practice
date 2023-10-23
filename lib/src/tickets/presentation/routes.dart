import 'package:bloc_practice/src/common/enums/form_modes.dart';
import 'package:bloc_practice/src/common/type_defs.dart';
import 'package:bloc_practice/src/tickets/data/tickets_memory_repository.dart';
import 'package:bloc_practice/src/tickets/domain/base_tickets_repository.dart';
import 'package:bloc_practice/src/tickets/domain/models/ticket.dart';
import 'package:bloc_practice/src/tickets/presentation/cubit/status_option_cubit.dart';
import 'package:bloc_practice/src/tickets/presentation/form/bloc/ticket_form_bloc.dart';
import 'package:bloc_practice/src/tickets/presentation/form/ticket_form_screen.dart';
import 'package:bloc_practice/src/tickets/presentation/list/bloc/ticket_list_bloc.dart';
import 'package:bloc_practice/src/tickets/presentation/list/ticket_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

TicketId _idFromRouter(BuildContext context, GoRouterState state) {
  try {
    return TicketId(
      value: int.parse(state.pathParameters['id']!),
      isTemporary: false,
    );
  } catch (e) {
    return state.extra as TicketId;
  }
}

RouteGuard invalidId(String prefix) {
  return (context, state) {
    final id = int.tryParse('${state.pathParameters['id']}');
    return id == null && state.extra is! TicketId ? '$prefix/notFound' : null;
  };
}

ShellRoute ticketsRouteConfiguration({
  required GlobalKey<NavigatorState> rootNavigator,
  String root = '/tickets',
}) {
  final shellKey = GlobalKey<NavigatorState>();

  return ShellRoute(
    parentNavigatorKey: rootNavigator,
    navigatorKey: shellKey,
    builder: (context, state, child) => MultiProvider(
      providers: [
        ChangeNotifierProvider<BaseTicketRepository>(
          create: (_) => TicketsMemoryRepository(),
        ),
        BlocProvider(
          create: (context) => StatusOptionCubit(
            context.read<BaseTicketRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => TicketListBloc(
            context.read<BaseTicketRepository>(),
          )..add(LoadList()),
        ),
      ],
      child: child,
    ),
    routes: [
      GoRoute(
        parentNavigatorKey: shellKey,
        name: 'ticket list',
        path: root,
        builder: (context, state) => const TicketListScreen(),
      ),
      GoRoute(
        parentNavigatorKey: shellKey,
        name: 'edit ticket',
        path: '$root/:id/edit',
        redirect: invalidId(root),
        builder: (context, state) => BlocProvider(
          create: (context) => TicketFormBloc(
            repo: context.read<BaseTicketRepository>(),
            mode: FormModes.edit,
            id: _idFromRouter(context, state),
          ),
          child: const TicketFormScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: shellKey,
        name: 'view ticket',
        path: '$root/:id/view',
        redirect: invalidId(root),
        builder: (context, state) => BlocProvider(
          create: (context) => TicketFormBloc(
            repo: context.read<BaseTicketRepository>(),
            mode: FormModes.view,
            id: _idFromRouter(context, state),
          ),
          child: const TicketFormScreen(),
        ),
      ),
    ],
  );
}
