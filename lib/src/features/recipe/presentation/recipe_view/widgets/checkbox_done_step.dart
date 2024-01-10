import 'package:ale/src/features/recipe/domain/entities/food_recipe.dart';
import 'package:ale/src/features/recipe/presentation/bloc/recipe_view_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckboxDoneStep extends StatelessWidget {
  final int number;
  final int total;
  final CookingStep step;

  const CheckboxDoneStep({
    super.key,
    required this.step,
    required this.number,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeViewBloc, RecipeViewState>(
      buildWhen: (_, current) {
        if (current.action is SetCompletedStep) {
          return (current.action as SetCompletedStep).value == step;
        }
        return current.action is AddStep || current.action is UpdateStep;
      },
      builder: (context, state) {
        final index = step.number.toString();
        return Row(
          children: [
            Checkbox(
              value: state.completed.contains(index),
              onChanged: (value) {
                context.read<RecipeViewBloc>().add(SetCompletedStep(
                      step,
                      value == true,
                    ));
              },
            ),
            Text(
              'Step $number/$total',
            ),
          ],
        );
      },
    );
  }
}
