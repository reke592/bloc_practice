import 'package:ale/src/features/recipe/presentation/bloc/recipe_view_bloc.dart';
import 'package:ale/src/features/recipe/presentation/recipe_view/widgets/label_ingredient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IngredientListView extends StatelessWidget {
  const IngredientListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeViewBloc, RecipeViewState>(
      buildWhen: (_, current) =>
          current.action is SetRecipeViewModel ||
          current.action is AddStep ||
          current.action is UpdateStep ||
          current.action is AdjustServing,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var item in state.data.allIngredients)
              LabelIngredient(ingredient: item),
          ],
        );
      },
    );
  }
}
