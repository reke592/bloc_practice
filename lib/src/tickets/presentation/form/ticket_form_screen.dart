import 'package:bloc_practice/src/common/enums/form_modes.dart';
import 'package:bloc_practice/src/common/exceptions/form_dirty_exception.dart';
import 'package:bloc_practice/src/common/exceptions/record_not_found.dart';
import 'package:bloc_practice/src/common/message_dialogs.dart';
import 'package:bloc_practice/src/tickets/presentation/form/bloc/ticket_form_bloc.dart';
import 'package:bloc_practice/src/tickets/presentation/form/widgets/button_close.dart';
import 'package:bloc_practice/src/tickets/presentation/form/widgets/button_edit.dart';
import 'package:bloc_practice/src/tickets/presentation/form/widgets/button_save.dart';
import 'package:bloc_practice/src/tickets/presentation/form/widgets/dropdown_status.dart';
import 'package:bloc_practice/src/tickets/presentation/form/widgets/input_narration.dart';
import 'package:bloc_practice/src/tickets/presentation/form/widgets/input_title.dart';
import 'package:bloc_practice/src/tickets/presentation/widgets/ticket_number.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class TicketFormScreen extends StatelessWidget {
  const TicketFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TicketFormBloc, TicketFormState>(
      listener: (context, state) async {
        final bloc = context.read<TicketFormBloc>();
        // on success
        if (state.mutation == TicketFormStates.success) {
          if (state.action is FormClose || state.action is FormSave) {
            context.goNamed('ticket list');
          }
        }
        // on error
        else if (state.mutation == TicketFormStates.error) {
          // when form is dirty
          if (state.error is FormDirtyException) {
            return MessageDialogs.confirm(
              context,
              message: state.error.toString(),
            ).then((proceed) {
              if (proceed) {
                bloc.add(const FormClose(true));
              }
            });
          }
          // when record not found
          else if (state.error is RecordNotFoundException) {
            return MessageDialogs.showError(context, state.error!)
                .then((_) => context.goNamed('ticket list'));
          }
          // default behavior
          else {
            return MessageDialogs.showError(context, state.error!);
          }
        }
      },
      builder: (context, state) {
        // print(state.data.status);
        final bloc = context.read<TicketFormBloc>();
        final isLandscape =
            MediaQuery.of(context).orientation == Orientation.landscape;
        if (state.mutation == TicketFormStates.initial) {
          bloc
            ..add(LoadDetails(bloc.state.data.id))
            ..add(LoadTicketHistory(bloc.state.data.id));
        }
        return Scaffold(
          appBar: AppBar(
            leading: const ButtonClose(),
            actions: [
              if (state.mode == FormModes.edit) const ButtonSave(),
              if (state.mode == FormModes.view) const ButtonEdit(),
            ],
          ),
          body: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TicketNumber(
                        id: state.data.id,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const DropdownStatus(),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (isLandscape)
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: InputTitle()),
                        SizedBox(width: 10),
                        Expanded(child: InputNarration()),
                      ],
                    ),
                  if (!isLandscape)
                    const Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InputTitle(),
                          SizedBox(height: 10),
                          InputNarration(),
                        ],
                      ),
                    )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
