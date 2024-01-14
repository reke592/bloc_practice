import 'package:equatable/equatable.dart';

part 'cooking_step.dart';
part 'ingredient.dart';

/// {@template food_recipe}
/// Food Recipe domain aggregate root entity.
/// {@endtemplate}
class FoodRecipe extends Equatable {
  /// {@macro food_recipe}
  const FoodRecipe({
    required this.id,
    required this.name,
    required this.serving,
    required this.steps,
    required this.description,
  });
  final int? id;
  final String name;
  final String description;
  final int serving;
  final List<CookingStep> steps;

  /// list of all ingredients from cooking steps
  List<Ingredient> get allIngredients => steps.fold(
        <Ingredient>[],
        (list, step) => step.active ? [...list, ...step.ingredients] : list,
      );

  @override
  List<Object?> get props => [id, name, serving, ...steps, description];
}
