import 'package:ale/src/features/recipe/data/models/cooking_step_model.dart';
import 'package:flutter/material.dart';

class ButtonCookingStepTimer extends StatelessWidget {
  final CookingStepModel step;

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
