import 'package:ale/src/features/recipe/domain/entities/food_recipe.dart';
import 'package:ale/src/features/recipe/presentation/bloc/edit_cooking_step_bloc.dart';
import 'package:ale/src/features/recipe/presentation/bloc/recipe_view_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ButtonEditCookingStep extends StatelessWidget {
  final CookingStep step;
  const ButtonEditCookingStep({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.pushNamed(
          'edit Cooking Step',
          extra: SetEditCookingStepViewModel(
            recipe: context.read<RecipeViewBloc>().state.data,
            step: step,
            isNew: false,
          ),
        );
      },
      icon: const Icon(Icons.edit),
    );
  }
}
