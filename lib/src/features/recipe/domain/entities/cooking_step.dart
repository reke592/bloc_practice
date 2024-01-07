part of 'food_recipe.dart';

class CookingStep {
  final int number;

  /// cooking duration
  final Duration duration;
  final List<Ingredient> ingredients;
  final String instructions;
  final bool active;

  const CookingStep({
    required this.number,
    required this.duration,
    required this.ingredients,
    required this.instructions,
    required this.active,
  });

  const CookingStep.empty()
      : this(
          number: 0,
          duration: const Duration(),
          ingredients: const [],
          instructions: 'instructions',
          active: true,
        );
}
