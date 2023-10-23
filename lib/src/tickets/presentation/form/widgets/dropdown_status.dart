import 'package:bloc_practice/src/common/enums/form_modes.dart';
import 'package:bloc_practice/src/common/extensions.dart';
import 'package:bloc_practice/src/tickets/presentation/form/bloc/ticket_form_bloc.dart';
import 'package:bloc_practice/src/tickets/presentation/widgets/ticket_status_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DropdownStatus extends StatelessWidget {
  const DropdownStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TicketFormBloc, TicketFormState>(
      buildWhen: (_, current) =>
          current.action is LoadDetails ||
          current.action is UpdateTicketStatus ||
          current.action is FormEdit,
      builder: (context, state) {
        final bloc = context.read<TicketFormBloc>();
        return TicketStatusDropdown(
          readOnly: state.mode == FormModes.view,
          value: state.data.status,
          onChanged: (value) {
            if (value != null) {
              bloc.add(UpdateTicketStatus(value));
            }
          },
        ).addShimmer(state.mutation == TicketFormStates.loading);
      },
    );
  }
}
