import 'package:bloc_practice/src/tickets/presentation/list/bloc/ticket_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ButtonRefreshList extends StatelessWidget {
  const ButtonRefreshList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TicketListBloc, TicketListState>(
      buildWhen: (_, current) =>
          current.action is LoadList || current.action is FilteredList,
      builder: (context, state) {
        return IconButton(
          onPressed: state.isLoading
              ? null
              : () {
                  context.read<TicketListBloc>().add(LoadList());
                },
          icon: state.isLoading
              ? const SizedBox.square(
                  dimension: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : const Icon(Icons.sync),
        );
      },
    );
  }
}
