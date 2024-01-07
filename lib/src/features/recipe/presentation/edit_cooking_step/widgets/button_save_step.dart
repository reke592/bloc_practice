import 'package:ale/src/features/recipe/presentation/bloc/edit_cooking_step_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ButtonSaveStep extends StatelessWidget {
  const ButtonSaveStep({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditCookingStepBloc, EditCookingStepState>(
      buildWhen: (_, current) => current.action is SaveChanges,
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state.isLoading
              ? null
              : () {
                  context.read<EditCookingStepBloc>().add(SaveChanges());
                },
          child: const Text('Save'),
        );
      },
    );
  }
}
