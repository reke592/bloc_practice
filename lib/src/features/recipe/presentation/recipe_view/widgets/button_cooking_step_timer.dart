import 'package:ale/src/features/recipe/domain/entities/food_recipe.dart';
import 'package:flutter/material.dart';

class ButtonCookingStepTimer extends StatelessWidget {
  final CookingStep step;

  const ButtonCookingStepTimer({
    super.key,
    required this.step,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.timer),
      label: Text(step.duration.toString().split('.')[0]),
    );
  }
}
