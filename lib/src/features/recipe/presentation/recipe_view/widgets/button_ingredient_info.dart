import 'package:ale/src/features/recipe/domain/entities/food_recipe.dart';
import 'package:flutter/material.dart';

class ButtonIngredientInfo extends StatelessWidget {
  const ButtonIngredientInfo({
    required this.ingredient,
    super.key,
  });
  final Ingredient ingredient;

  @override
  Widget build(BuildContext context) {
    // TODO(erric): display recipe image on opressed.
    return OutlinedButton(
      onPressed: () {},
      style: Theme.of(context).outlinedButtonTheme.style?.copyWith(
            textStyle: MaterialStateProperty.resolveWith(
              (states) => Theme.of(context).textTheme.bodySmall,
            ),
          ),
      child: Text(ingredient.toString()),
    );
  }
}
