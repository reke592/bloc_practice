import 'package:bloc_practice/src/tickets/domain/models/ticket.dart';
import 'package:bloc_practice/src/tickets/presentation/list/bloc/ticket_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ButtonCreate extends StatelessWidget {
  const ButtonCreate({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        final tempId = TicketId.temporary(
            context.read<TicketListBloc>().state.tickets.length + 1);
        context.goNamed(
          'edit ticket',
          extra: tempId,
          pathParameters: {'id': '$tempId'},
        );
      },
      child: const Text('Create New Ticket'),
    );
  }
}
