import 'package:bloc_practice/src/common/enums/form_modes.dart';
import 'package:bloc_practice/src/common/extensions/shimmer_effect_on_widget.dart';
import 'package:bloc_practice/src/tickets/presentation/form/bloc/ticket_form_bloc.dart';
import 'package:bloc_practice/src/tickets/presentation/widgets/common_dropdown_customers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DropdownCustomers extends StatelessWidget {
  final bool isExpanded;
  const DropdownCustomers({
    super.key,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TicketFormBloc, TicketFormState>(
      buildWhen: (_, current) =>
          current.action is LoadDetails ||
          current.action is TagCustomer ||
          current.action is FormEdit,
      builder: (context, state) {
        final bloc = context.read<TicketFormBloc>();
        return CommonDropdownCustomers(
          isExpanded: isExpanded,
          readOnly: state.mode == FormModes.view,
          value: state.data.customer,
          onChanged: (value) {
            if (value != null) {
              bloc.add(TagCustomer(value));
            }
          },
        ).addShimmer(state.isLoading);
      },
    );
  }
}
