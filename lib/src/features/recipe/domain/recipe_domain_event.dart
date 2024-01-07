import 'package:ale/src/features/recipe/domain/entities/food_recipe.dart';
import 'package:equatable/equatable.dart';

sealed class RecipeDomainEvent extends Equatable {}

class RecipeDetailsUpdated extends RecipeDomainEvent {
  final FoodRecipe value;
  RecipeDetailsUpdated(this.value);

  @override
  List<Object?> get props => [value];
}

class RecipeStepsUpdated extends RecipeDomainEvent {
  final int recipeId;
  final CookingStep value;
  final bool isNew;
  RecipeStepsUpdated({
    required this.recipeId,
    required this.value,
    required this.isNew,
  });

  @override
  List<Object?> get props => [recipeId, value, isNew];
}

class RecipeStepsRemoved extends RecipeDomainEvent {
  final int recipeId;
  final int number;
  final bool isPermanent;
  RecipeStepsRemoved({
    required this.recipeId,
    required this.number,
    required this.isPermanent,
  });

  @override
  List<Object?> get props => [recipeId, number, isPermanent];
}
