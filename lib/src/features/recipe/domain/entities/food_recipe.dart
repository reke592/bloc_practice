part 'cooking_step.dart';
part 'ingredient.dart';

/// {@template food_recipe}
/// Food Recipe domain aggregate root entity.
/// {@endtemplate}
class FoodRecipe {
  final int? id;
  final String name;
  final String description;
  final int serving;
  final List<CookingStep> steps;

  /// {@macro food_recipe}
  const FoodRecipe({
    required this.id,
    required this.name,
    required this.serving,
    required this.steps,
    required this.description,
  });

  const FoodRecipe.empty()
      : this(
          id: null,
          name: 'name',
          serving: 1,
          description: 'description',
          steps: const [],
        );
}
