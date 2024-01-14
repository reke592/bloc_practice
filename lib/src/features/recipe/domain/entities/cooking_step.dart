part of 'food_recipe.dart';

class CookingStep extends Equatable {
  const CookingStep({
    required this.number,
    required this.duration,
    required this.ingredients,
    required this.instructions,
    required this.active,
  });
  final int number;

  /// cooking duration
  final Duration duration;
  final List<Ingredient> ingredients;
  final String instructions;
  final bool active;

  @override
  List<Object?> get props => [
        number,
        duration.toString(),
        ...ingredients,
        instructions,
        active,
      ];
}
