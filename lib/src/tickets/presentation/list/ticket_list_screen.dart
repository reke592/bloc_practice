import 'package:bloc_practice/src/common/widgets/filter_options.dart';
import 'package:bloc_practice/src/tickets/presentation/list/bloc/ticket_list_bloc.dart';
import 'package:bloc_practice/src/tickets/presentation/list/widgets/button_create.dart';
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
        title: const Text('Tickets'),
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
          if (state.mutation == TicketListStates.loading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.grey,
              ),
            );
          }

          return Column(
            children: [
              const Row(
                children: [
                  Spacer(),
                  ButtonShowFilters(),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: state.tickets.length,
                  itemBuilder: (context, index) {
                    final textTheme = Theme.of(context).textTheme;
                    return ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TicketNumber(id: state.tickets[index].id),
                          Text(state.tickets[index].title),
                        ],
                      ),
                      titleTextStyle: textTheme.bodyMedium,
                      subtitleTextStyle: textTheme.bodySmall?.copyWith(
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(state.tickets[index].customer),
                          Text(state.tickets[index].narration),
                          Text(state.tickets[index].created.toString()),
                        ],
                      ),
                      trailing: Text(state.tickets[index].status),
                      onTap: () => context.goNamed(
                        'view ticket',
                        pathParameters: {
                          'id': state.tickets[index].id.toString(),
                        },
                      ),
                    );
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
