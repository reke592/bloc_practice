import 'package:ale/src/features/recipe/domain/entities/food_recipe.dart';
import 'package:flutter/material.dart';

class ButtonCookingStepTimer extends StatelessWidget {
  const ButtonCookingStepTimer({
    required this.step,
    super.key,
  });
  final CookingStep step;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.timer),
      label: Text(step.duration.toString().split('.')[0]),
    );
  }
}
