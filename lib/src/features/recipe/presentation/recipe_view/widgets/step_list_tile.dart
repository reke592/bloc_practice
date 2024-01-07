import 'package:ale/src/features/recipe/data/models/cooking_step_model.dart';
import 'package:ale/src/features/recipe/presentation/recipe_view/widgets/button_cooking_step_timer.dart';
import 'package:ale/src/features/recipe/presentation/recipe_view/widgets/button_edit_cooking_step.dart';
import 'package:ale/src/features/recipe/presentation/recipe_view/widgets/button_ingredient_info.dart';
import 'package:ale/src/features/recipe/presentation/recipe_view/widgets/checkbox_done_step.dart';
import 'package:flutter/material.dart';

class StepListTile extends StatelessWidget {
  final CookingStepModel step;
  final int number;
  final int total;

  const StepListTile({
    super.key,
    required this.step,
    required this.number,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CheckboxDoneStep(
            step: step,
            number: number,
            total: total,
          ),
          const Spacer(),
          if (step.duration.inSeconds > 0) ButtonCookingStepTimer(step: step),
          ButtonEditCookingStep(step: step),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (step.ingredients.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8,
                children: [
                  for (var item in step.ingredients)
                    ButtonIngredientInfo(ingredient: item)
                ],
              ),
            ),
          Text(step.instructions),
        ],
      ),
    );
  }
}
