part of 'recipe_view_bloc.dart';

sealed class RecipeViewEvent extends Equatable {
  const RecipeViewEvent();

  @override
  List<Object?> get props => [];
}

class SetRecipeViewModel extends RecipeViewEvent {
  const SetRecipeViewModel(this.data);
  final FoodRecipe data;
  @override
  List<Object?> get props => [data];
}

class SetCompletedStep extends RecipeViewEvent {
  const SetCompletedStep({
    required this.value,
    required this.isCompleted,
  });
  final CookingStep value;
  final bool isCompleted;

  @override
  List<Object?> get props => [value];
}

class AdjustServing extends RecipeViewEvent {
  const AdjustServing(this.value);
  final int? value;
  @override
  List<Object?> get props => [value];
}

class ChangeRecipeDetails extends RecipeViewEvent {
  const ChangeRecipeDetails({
    required this.name,
    required this.description,
    required this.servings,
  });
  final String name;
  final String description;
  final int servings;

  @override
  List<Object?> get props => [name, description, servings];
}

class AddStep extends RecipeViewEvent {
  const AddStep(this.value);
  final CookingStepModel value;
  @override
  List<Object?> get props => [value];
}

class UpdateStep extends RecipeViewEvent {
  const UpdateStep(this.value);
  final CookingStepModel value;
  @override
  List<Object?> get props => [value];
}

class RemoveStep extends RecipeViewEvent {
  // final CookingStepModel value;
  const RemoveStep(this.number);
  final int number;
  @override
  List<Object?> get props => [number];
}
