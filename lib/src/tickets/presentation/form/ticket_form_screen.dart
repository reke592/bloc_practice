import 'package:bloc_practice/src/common/enums/form_modes.dart';
import 'package:bloc_practice/src/common/exceptions/form_dirty_exception.dart';
import 'package:bloc_practice/src/common/exceptions/record_not_found.dart';
import 'package:bloc_practice/src/common/message_dialogs.dart';
import 'package:bloc_practice/src/common/observers/previous_route_observer.dart';
import 'package:bloc_practice/src/tickets/presentation/form/bloc/ticket_form_bloc.dart';
import 'package:bloc_practice/src/tickets/presentation/form/widgets/button_close.dart';
import 'package:bloc_practice/src/tickets/presentation/form/widgets/button_edit.dart';
import 'package:bloc_practice/src/tickets/presentation/form/widgets/button_save.dart';
import 'package:bloc_practice/src/tickets/presentation/form/widgets/dropdown_customers.dart';
import 'package:bloc_practice/src/tickets/presentation/form/widgets/dropdown_status.dart';
import 'package:bloc_practice/src/tickets/presentation/form/widgets/input_narration.dart';
import 'package:bloc_practice/src/tickets/presentation/form/widgets/input_title.dart';
import 'package:bloc_practice/src/common/widgets/previous_route_name.dart';
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
        if (state.isSuccess) {
          if (state.action is FormSave) {
            return context.goNamed('ticket list');
          }
          if (state.action is FormClose) {
            var prev = PreviousRouteObserver.value?.settings.name;
            if (prev == 'view ticket' || prev == 'new ticket') {
              return context.pop();
            } else {
              return context.goNamed('ticket list');
            }
          }
        }
        // on error
        else if (state.isError) {
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
      buildWhen: (_, current) =>
          current.action is LoadDetails || current.action is FormEdit,
      builder: (context, state) {
        final isLandscape =
            MediaQuery.orientationOf(context) == Orientation.landscape;
        return Scaffold(
          appBar: AppBar(
            leading: const ButtonClose(),
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ticket Form'),
                PreviousRouteName(),
              ],
            ),
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
                  // web and tablet
                  if (isLandscape)
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InputTitle(),
                              DropdownCustomers(),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(child: InputNarration()),
                      ],
                    ),
                  // mobile
                  if (!isLandscape)
                    const Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          InputTitle(),
                          SizedBox(height: 10),
                          DropdownCustomers(),
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
