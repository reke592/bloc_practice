import 'package:ale/src/features/recipe/data/models/food_recipe_model.dart';
import 'package:ale/src/features/recipe/presentation/bloc/recipe_view_bloc.dart';
import 'package:ale/src/features/recipe/presentation/dialogs/recipe_description_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IntroductionRecipe extends StatelessWidget {
  const IntroductionRecipe({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeViewBloc, RecipeViewState>(
      buildWhen: (_, current) =>
          current.action is SetRecipeViewModel ||
          current.action is ChangeRecipeDetails,
      builder: (context, state) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    state.data.name,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog<RecipeDescriptionDialogResult>(
                      useRootNavigator: false,
                      context: context,
                      builder: (dialogContext) {
                        return RecipeDescriptionDialog(
                          data: state.data as FoodRecipeModel,
                        );
                      },
                    ).then((value) {
                      if (value is RecipeDescriptionDialogResult) {
                        context.read<RecipeViewBloc>().add(
                              ChangeRecipeDetails(
                                name: value.name,
                                description: value.description,
                                servings: value.servings,
                              ),
                            );
                      }
                    });
                  },
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),
            Text(state.data.description),
          ],
        );
      },
    );
  }
}
