import 'package:ale/src/features/recipe/presentation/bloc/recipe_view_bloc.dart';
import 'package:ale/src/features/recipe/presentation/recipe_view/widgets/step_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StepListView extends StatelessWidget {
  const StepListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeViewBloc, RecipeViewState>(
      buildWhen: (_, current) =>
          current.action is SetRecipeViewModel ||
          current.action is AddStep ||
          current.action is UpdateStep,
      builder: (context, state) {
        final steps =
            state.data.steps.where((element) => element.active).toList();
        return Column(
          children: [
            for (var i = 0; i < steps.length; i++)
              StepListTile(step: steps[i], number: i + 1, total: steps.length)
          ],
        );
      },
    );
  }
}
