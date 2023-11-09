import 'package:bloc_practice/src/common/extensions/shimmer_effect_on_widget.dart';
import 'package:bloc_practice/src/tickets/presentation/cubit/customer_option_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommonDropdownCustomers extends StatelessWidget {
  final void Function(String? value)? onChanged;
  final String? value;
  final bool readOnly;
  final bool? parentIsLoading;
  final bool isExpanded;
  final bool isDense;

  const CommonDropdownCustomers({
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
    return BlocBuilder<CustomerOptionCubit, CustomerOptionState>(
      builder: (context, state) {
        bool isLoading = parentIsLoading ?? state.isLoading;
        return DropdownButton<String>(
          isDense: isDense,
          isExpanded: isExpanded,
          underline: Container(),
          borderRadius: BorderRadius.circular(8),
          value: value?.isEmpty ?? true ? null : value,
          hint: const Text('Customer'),
          items: [
            for (var option in state.options)
              DropdownMenuItem(
                value: option,
                child: Text(option),
              ),
          ],
          onChanged: readOnly || isLoading ? null : onChanged,
        ).addShimmer(isLoading);
      },
    );
  }
}
