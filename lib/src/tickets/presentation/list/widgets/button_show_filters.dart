import 'package:bloc_practice/src/common/widgets/filtered_results_label.dart';
import 'package:bloc_practice/src/tickets/presentation/list/bloc/ticket_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ButtonShowFilters extends StatelessWidget {
  const ButtonShowFilters({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TicketListBloc, TicketListState>(
      builder: (context, state) {
        return Row(
          children: [
            FilteredResultsLabel(provider: context.read<TicketListBloc>()),
            IconButton(
              onPressed: () {
                if (Scaffold.of(context).isEndDrawerOpen == false) {
                  Scaffold.of(context).openEndDrawer();
                }
              },
              icon: const Icon(Icons.filter_alt_outlined),
            ),
          ],
        );
      },
    );
  }
}
