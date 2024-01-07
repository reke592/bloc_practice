import 'package:ale/src/features/recipe/presentation/bloc/recipe_list_bloc.dart';
import 'package:ale/src/features/recipe/presentation/dialogs/recipe_description_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class FABCreateRecipe extends StatelessWidget {
  const FABCreateRecipe({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeListBloc, RecipeListState>(
      builder: (context, state) {
        return Visibility(
          visible: state.selected.isEmpty,
          child: FloatingActionButton(
            onPressed: state.isLoading
                ? null
                : () {
                    showDialog(
                      context: context,
                      builder: (dialogContext) {
                        return const RecipeDescriptionDialog();
                      },
                    ).then((value) {
                      if (value is RecipeDescriptionDialogResult) {
                        context.read<RecipeListBloc>().add(
                              NewRecipe(
                                name: value.name,
                                description: value.description,
                                servings: value.servings,
                                onDone: (data) {
                                  context.pushNamed('view Recipe', extra: data);
                                },
                              ),
                            );
                      }
                    });
                  },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
