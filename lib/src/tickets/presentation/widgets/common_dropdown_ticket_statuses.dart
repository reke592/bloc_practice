import 'package:bloc_practice/src/common/extensions/shimmer_effect_on_widget.dart';
import 'package:bloc_practice/src/tickets/presentation/cubit/status_option_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommonDropdownTicketStatuses extends StatelessWidget {
  final void Function(String? value)? onChanged;
  final String? value;
  final bool readOnly;
  final bool? parentIsLoading;
  final bool isExpanded;
  final bool isDense;

  const CommonDropdownTicketStatuses({
    super.key,
    required this.onChanged,
    this.value,
    this.readOnly = false,
    this.parentIsLoading,
    this.isDense = false,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatusOptionCubit, StatusOptionState>(
      builder: (context, state) {
        bool isLoading = parentIsLoading ?? state.isLoading;
        if (state.isInitial) {
          context.read<StatusOptionCubit>().loadList();
        }
        return DropdownButton<String>(
          isDense: isDense,
          isExpanded: isExpanded,
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
