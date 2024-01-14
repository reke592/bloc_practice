part of 'recipe_list_bloc.dart';

sealed class RecipeListEvent extends Equatable {
  const RecipeListEvent();

  @override
  List<Object> get props => [];
}

class LoadFoodRecipes extends RecipeListEvent {
  const LoadFoodRecipes({this.page = 0});
  final int page;
  @override
  List<Object> get props => [page];
}

class NewRecipe extends RecipeListEvent {
  const NewRecipe({
    required this.name,
    required this.description,
    required this.servings,
    required this.onDone,
  });
  final String name;
  final String description;
  final int servings;
  final void Function(FoodRecipe created) onDone;
  @override
  List<Object> get props => [name, description, servings, onDone];
}

class SelectItem extends RecipeListEvent {
  const SelectItem({
    required this.value,
    required this.isSelected,
  });
  final FoodRecipe value;
  final bool isSelected;
  @override
  List<Object> get props => [value, isSelected];
}

class ClearSelected extends RecipeListEvent {}

class DeleteSelected extends RecipeListEvent {}

class ReplaceExistingItem extends RecipeListEvent {
  const ReplaceExistingItem(this.value);
  final FoodRecipe value;
  @override
  List<Object> get props => [value];
}
