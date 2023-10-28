import 'package:bloc_practice/src/common/enums/form_modes.dart';
import 'package:bloc_practice/src/common/extensions/shimmer_effect_on_widget.dart';
import 'package:bloc_practice/src/tickets/presentation/form/bloc/ticket_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InputNarration extends StatelessWidget {
  const InputNarration({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TicketFormBloc>();
    return BlocBuilder<TicketFormBloc, TicketFormState>(
      buildWhen: (_, current) =>
          current.action is LoadDetails || current.action is FormEdit,
      builder: (context, state) {
        final controller = TextEditingController(text: state.data.narration);
        final readOnly = state.mode == FormModes.view;
        return TextField(
          readOnly: readOnly,
          controller: controller,
          minLines: 5,
          maxLines: 5,
          decoration: const InputDecoration(label: Text('Narration')),
          onChanged: !readOnly
              ? (value) {
                  bloc.add(UpdateNarration(value));
                }
              : null,
        ).addShimmer(state.isLoading);
      },
    );
  }
}
