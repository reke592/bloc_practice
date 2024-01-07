import 'package:ale/src/features/recipe/data/models/ingredient_model.dart';
import 'package:ale/src/features/recipe/presentation/bloc/recipe_view_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LabelIngredient extends StatelessWidget {
  final IngredientModel ingredient;
  const LabelIngredient({
    super.key,
    required this.ingredient,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: dictionary, to make it easy to read ingredients
    return BlocBuilder<RecipeViewBloc, RecipeViewState>(
      builder: (context, state) {
        double amount = ingredient.amount;
        if (state.adjustedServing != null &&
            state.adjustedServing != state.data.serving) {
          amount =
              ingredient.amount / (state.data.serving / state.adjustedServing!);
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
                    color:
                        amount != ingredient.amount ? Colors.grey[300] : null,
                    fontWeight:
                        amount != ingredient.amount ? null : FontWeight.bold,
                  ),
            ),
            // with serving adjusment
            if (amount != ingredient.amount)
              Text(
                ' ~ ${amount.toStringAsFixed(2)} ${ingredient.unit}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
          ],
        );
      },
    );
  }
}
