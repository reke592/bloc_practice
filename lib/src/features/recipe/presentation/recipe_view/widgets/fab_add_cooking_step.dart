import 'package:ale/src/features/recipe/data/models/cooking_step_model.dart';
import 'package:ale/src/features/recipe/presentation/bloc/recipe_view_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class FABAddCookingStep extends StatelessWidget {
  const FABAddCookingStep({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: add cooking step
    return FloatingActionButton(
      onPressed: () {
        final recipe = context.read<RecipeViewBloc>().state.data;
        context.pushNamed('edit Cooking Step', extra: [
          recipe,
          CookingStepModel(number: recipe.steps.length + 1),
        ]);
      },
      child: const Icon(Icons.add),
    );
  }
}
