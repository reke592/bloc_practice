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
        return TextButton.icon(
          onPressed: state.isLoading
              ? null
              : () {
                  context.read<TicketFormBloc>().add(FormEdit());
                },
          icon: const Icon(Icons.edit_outlined),
          label: const Text('Edit'),
        );
      },
    );
  }
}
