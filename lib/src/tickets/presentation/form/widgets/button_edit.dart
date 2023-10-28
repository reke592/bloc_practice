import 'package:bloc_practice/src/common/extensions/shimmer_effect_on_widget.dart';
import 'package:bloc_practice/src/tickets/presentation/form/bloc/ticket_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ButtonEdit extends StatelessWidget {
  const ButtonEdit({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TicketFormBloc, TicketFormState>(
      buildWhen: (_, current) => current.action is LoadDetails,
      builder: (context, state) {
        return ElevatedButton(
          onPressed: () {
            context.read<TicketFormBloc>().add(FormEdit());
          },
          child: const Text('Edit'),
        ).addShimmer(state.isLoading);
      },
    );
  }
}
