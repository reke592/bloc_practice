import 'package:bloc_practice/src/common/extensions/shimmer_effect_on_widget.dart';
import 'package:bloc_practice/src/common/widgets/filter_options.dart';
import 'package:bloc_practice/src/common/widgets/previous_route_name.dart';
import 'package:bloc_practice/src/tickets/domain/models/ticket.dart';
import 'package:bloc_practice/src/tickets/presentation/list/bloc/ticket_list_bloc.dart';
import 'package:bloc_practice/src/tickets/presentation/list/widgets/button_create.dart';
import 'package:bloc_practice/src/tickets/presentation/list/widgets/button_refresh_list.dart';
import 'package:bloc_practice/src/tickets/presentation/list/widgets/button_show_filters.dart';
import 'package:bloc_practice/src/tickets/presentation/widgets/ticket_number.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class TicketListScreen extends StatelessWidget {
  const TicketListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tickets'),
            PreviousRouteName(),
          ],
        ),
        leading: BackButton(
          onPressed: () => context.go('/'),
        ),
        actions: const [
          ButtonCreate(),
        ],
      ),
      endDrawer: Drawer(
        child: FilterOptions(provider: context.read<TicketListBloc>()),
      ),
      body: BlocConsumer<TicketListBloc, TicketListState>(
        listener: (context, state) {},
        buildWhen: (_, current) =>
            current.action is LoadList || current.action is FilteredList,
        builder: (context, state) {
          final list = state.isLoading
              ? List.generate(
                  4,
                  (index) => Ticket(
                    id: TicketId(isTemporary: false, value: index),
                    title: 'Title',
                    customer: 'Customer',
                    narration: 'Narration',
                    status: 'Status',
                  ),
                )
              : state.action is! FilteredList
                  ? state.tickets
                  : (state.action as FilteredList).data;

          return Column(
            children: [
              const Row(
                children: [
                  Spacer(),
                  ButtonRefreshList(),
                  ButtonShowFilters(),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final textTheme = Theme.of(context).textTheme;
                    return ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TicketNumber(id: list[index].id),
                          Text(list[index].title),
                        ],
                      ),
                      titleTextStyle: textTheme.bodyMedium,
                      subtitleTextStyle: textTheme.bodySmall?.copyWith(
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(list[index].customer),
                          Text(list[index].narration),
                          Text(list[index].created?.toString() ?? ''),
                        ],
                      ),
                      trailing: Text(list[index].status),
                      // TODO: something is happenning with GoRouter
                      // when we use NoTransitionPage we are required to use pushNamed to get the previous route name
                      onTap: () => context.goNamed(
                        'view ticket',
                        pathParameters: {
                          'id': list[index].id.toString(),
                        },
                      ),
                    ).addShimmer(state.isLoading);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
