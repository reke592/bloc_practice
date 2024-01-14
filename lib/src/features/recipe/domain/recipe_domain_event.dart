import 'package:ale/src/features/recipe/domain/entities/food_recipe.dart';
import 'package:equatable/equatable.dart';

sealed class RecipeDomainEvent extends Equatable {}

class RecipeDetailsUpdated extends RecipeDomainEvent {
  RecipeDetailsUpdated(this.value);
  final FoodRecipe value;

  @override
  List<Object?> get props => [value];
}

class RecipeStepsUpdated extends RecipeDomainEvent {
  RecipeStepsUpdated({
    required this.recipeId,
    required this.value,
    required this.isNew,
  });
  final int recipeId;
  final CookingStep value;
  final bool isNew;

  @override
  List<Object?> get props => [recipeId, value, isNew];
}

class RecipeStepsRemoved extends RecipeDomainEvent {
  RecipeStepsRemoved({
    required this.recipeId,
    required this.number,
    required this.isPermanent,
  });
  final int recipeId;
  final int number;
  final bool isPermanent;

  @override
  List<Object?> get props => [recipeId, number, isPermanent];
}
