import 'package:ale/src/features/recipe/domain/entities/food_recipe.dart';
import 'package:ale/src/features/recipe/presentation/bloc/recipe_view_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LabelIngredient extends StatelessWidget {
  const LabelIngredient({
    required this.ingredient,
    super.key,
  });
  final Ingredient ingredient;

  @override
  Widget build(BuildContext context) {
    // TODO(erric): dictionary, to make it easy to read ingredients.
    return BlocBuilder<RecipeViewBloc, RecipeViewState>(
      buildWhen: (_, current) => current.action is AdjustServing,
      builder: (context, state) {
        var amount = ingredient.amount;
        var isAmountAjusted = false;

        if (state.adjustedServing != null &&
            state.adjustedServing != state.data.serving) {
          amount =
              ingredient.amount / (state.data.serving / state.adjustedServing!);
          isAmountAjusted = amount != ingredient.amount;
        }

        return Wrap(
          children: [
            Text(
              ingredient.name,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              ' ${ingredient.amount} ${ingredient.unit}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isAmountAjusted ? Colors.grey[300] : null,
                    fontWeight: isAmountAjusted ? null : FontWeight.bold,
                  ),
            ),
            // with serving adjusment
            if (isAmountAjusted)
              Text(
                ' ~ ${amount.toStringAsFixed(2)} ${ingredient.unit}',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
          ],
        );
      },
    );
  }
}
