import 'package:bloc_practice/src/tickets/presentation/list/bloc/ticket_list_bloc.dart';
import 'package:bloc_practice/src/tickets/presentation/list/widgets/button_create.dart';
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
      body: BlocConsumer<TicketListBloc, TicketListState>(
        listener: (context, state) {},
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
              Expanded(
                child: ListView.builder(
                  itemCount: state.tickets.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(state.tickets[index].title),
                      subtitle: Text(state.tickets[index].narration),
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
              Text('Total Records: ${state.tickets.length}'),
            ],
          );
        },
      ),
    );
  }
}
