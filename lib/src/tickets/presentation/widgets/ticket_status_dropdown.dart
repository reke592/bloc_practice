import 'package:bloc_practice/src/common/extensions.dart';
import 'package:bloc_practice/src/tickets/presentation/cubit/status_option_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TicketStatusDropdown extends StatelessWidget {
  final void Function(String? value)? onChanged;
  final String? value;
  final bool readOnly;

  const TicketStatusDropdown({
    super.key,
    required this.onChanged,
    this.value,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatusOptionCubit, StatusOptionState>(
      builder: (context, state) {
        if (state.mutation == StatusOptionStates.initial) {
          context.read<StatusOptionCubit>().loadList();
        }
        bool isLoading = state.mutation == StatusOptionStates.loading;
        return DropdownButton<String>(
          underline: Container(),
          borderRadius: BorderRadius.circular(8),
          value: value?.isEmpty ?? true ? null : value,
          hint: const Text('Ticket Status'),
          items: [
            for (var option in state.options)
              DropdownMenuItem(
                value: option.name,
                child: Text(option.name),
              ),
          ],
          onChanged: readOnly || isLoading ? null : onChanged,
        ).addShimmer(isLoading);
      },
    );
  }
}
