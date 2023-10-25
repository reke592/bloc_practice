import 'package:bloc_practice/src/common/enums/form_modes.dart';
import 'package:bloc_practice/src/common/extensions.dart';
import 'package:bloc_practice/src/tickets/presentation/form/bloc/ticket_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InputTitle extends StatelessWidget {
  const InputTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TicketFormBloc, TicketFormState>(
      buildWhen: (_, current) =>
          current.action is LoadDetails || current.action is FormEdit,
      builder: (context, state) {
        final controller = TextEditingController(text: state.data.title);
        final readOnly = state.mode == FormModes.view;
        return TextField(
          readOnly: readOnly,
          controller: controller,
          decoration: const InputDecoration(
            label: Text('Title'),
            border: OutlineInputBorder(),
          ),
          onChanged: !readOnly
              ? (value) {
                  context.read<TicketFormBloc>().add(UpdateTitle(value));
                }
              : null,
        ).addShimmer(state.mutation == TicketFormStates.loading);
      },
    );
  }
}
