import 'package:ale/src/features/recipe/data/models/ingredient_model.dart';
import 'package:ale/src/features/recipe/presentation/bloc/edit_cooking_step_bloc.dart';
import 'package:ale/src/features/recipe/presentation/dialogs/ingredient_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IngredientListView extends StatelessWidget {
  const IngredientListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditCookingStepBloc, EditCookingStepState>(
      builder: (context, state) {
        return ListView.builder(
          itemCount: state.data.ingredients.length,
          itemBuilder: (context, index) {
            final item = state.data.ingredients[index];
            return ListTile(
              contentPadding: const EdgeInsets.all(0),
              dense: true,
              title: Text(item.name),
              subtitle: Text('${item.amount} ${item.unit}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      context
                          .read<EditCookingStepBloc>()
                          .add(RemoveIngredient(item as IngredientModel));
                    },
                    icon: const Icon(Icons.delete),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (dialogContext) {
                          return IngredientDialog(
                            value: item as IngredientModel,
                          );
                        },
                      ).then((result) {
                        if (result is IngredientDialogResult) {
                          context
                              .read<EditCookingStepBloc>()
                              .add(UpdateIngredient(
                                oldValue: item as IngredientModel,
                                newValue: result.value,
                              ));
                        }
                      });
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
