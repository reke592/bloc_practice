import 'package:ale/src/features/recipe/presentation/bloc/edit_cooking_step_bloc.dart';
import 'package:ale/src/features/recipe/presentation/dialogs/ingredient_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ButtonAddIngredient extends StatelessWidget {
  const ButtonAddIngredient({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        showDialog<IngredientDialogResult>(
          context: context,
          builder: (dialogContext) {
            return const IngredientDialog();
          },
        ).then((result) {
          if (result is IngredientDialogResult) {
            context
                .read<EditCookingStepBloc>()
                .add(AddIngredient(result.value));
          }
        });
      },
      icon: const Icon(Icons.add),
      label: const Text('Add Ingredient'),
    );
  }
}
