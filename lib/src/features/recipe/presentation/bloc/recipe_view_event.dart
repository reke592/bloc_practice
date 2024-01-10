part of 'recipe_view_bloc.dart';

sealed class RecipeViewEvent extends Equatable {
  const RecipeViewEvent();

  @override
  List<Object?> get props => [];
}

class SetRecipeViewModel extends RecipeViewEvent {
  final FoodRecipe data;
  const SetRecipeViewModel(this.data);
  @override
  List<Object?> get props => [data];
}

class SetCompletedStep extends RecipeViewEvent {
  final CookingStep value;
  final bool isCompleted;

  const SetCompletedStep(this.value, this.isCompleted);

  @override
  List<Object?> get props => [value];
}

class AdjustServing extends RecipeViewEvent {
  final int? value;
  const AdjustServing(this.value);
  @override
  List<Object?> get props => [value];
}

class ChangeRecipeDetails extends RecipeViewEvent {
  final String name;
  final String description;
  final int servings;

  const ChangeRecipeDetails({
    required this.name,
    required this.description,
    required this.servings,
  });

  @override
  List<Object?> get props => [name, description, servings];
}

class AddStep extends RecipeViewEvent {
  final CookingStepModel value;
  const AddStep(this.value);
  @override
  List<Object?> get props => [value];
}

class UpdateStep extends RecipeViewEvent {
  final CookingStepModel value;
  const UpdateStep(this.value);
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
