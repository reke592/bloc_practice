import 'package:ale/src/commons/message_dialog.dart';
import 'package:ale/src/features/recipe/presentation/bloc/edit_cooking_step_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ButtonDeleteStep extends StatelessWidget {
  const ButtonDeleteStep({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {
        MessageDialog.confirm(
          context,
          message: 'Are you sure you want to delete this cooking step?',
        ).then((proceed) {
          if (proceed) {
            context.read<EditCookingStepBloc>().add(DeleteStep());
          }
        });
      },
      icon: const Icon(
        Icons.delete,
        color: Colors.red,
      ),
      label: const Text('Delete'),
    );
  }
}
