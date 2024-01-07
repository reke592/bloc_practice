import 'package:ale/src/features/recipe/data/models/cooking_step_model.dart';
import 'package:ale/src/features/recipe/presentation/bloc/recipe_view_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ButtonEditCookingStep extends StatelessWidget {
  final CookingStepModel step;
  const ButtonEditCookingStep({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.pushNamed('edit Cooking Step', extra: [
          context.read<RecipeViewBloc>().state.data,
          step,
        ]);
      },
      icon: const Icon(Icons.edit),
    );
  }
}
