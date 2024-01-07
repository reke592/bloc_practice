import 'package:ale/src/features/recipe/domain/entities/food_recipe.dart';
import 'package:flutter/material.dart';

class ButtonIngredientInfo extends StatelessWidget {
  final Ingredient ingredient;

  const ButtonIngredientInfo({
    super.key,
    required this.ingredient,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: display recipe image on opressed
    return OutlinedButton(
      onPressed: () {},
      style: Theme.of(context).outlinedButtonTheme.style?.copyWith(
            textStyle: MaterialStateProperty.resolveWith(
                (states) => Theme.of(context).textTheme.bodySmall),
          ),
      child: Text(ingredient.toString()),
    );
  }
}
