import 'package:bloc_practice/src/common/extensions/shimmer_effect_on_widget.dart';
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
          onPressed: () {
            context.read<TicketListBloc>().add(LoadList());
          },
          icon: const Icon(Icons.sync),
        ).addShimmer(state.isLoading);
      },
    );
  }
}
