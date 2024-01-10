part of 'recipe_list_bloc.dart';

sealed class RecipeListEvent extends Equatable {
  const RecipeListEvent();

  @override
  List<Object> get props => [];
}

class LoadFoodRecipes extends RecipeListEvent {
  final int page;
  const LoadFoodRecipes({this.page = 0});
  @override
  List<Object> get props => [page];
}

class NewRecipe extends RecipeListEvent {
  final String name;
  final String description;
  final int servings;
  final Function(FoodRecipe created) onDone;
  const NewRecipe({
    required this.name,
    required this.description,
    required this.servings,
    required this.onDone,
  });
  @override
  List<Object> get props => [name, description, servings, onDone];
}

class SelectItem extends RecipeListEvent {
  final FoodRecipe value;
  final bool isSelected;
  const SelectItem({
    required this.value,
    required this.isSelected,
  });
  @override
  List<Object> get props => [value, isSelected];
}

class ClearSelected extends RecipeListEvent {}

class DeleteSelected extends RecipeListEvent {}

class ReplaceExistingItem extends RecipeListEvent {
  final FoodRecipe value;
  const ReplaceExistingItem(this.value);
  @override
  List<Object> get props => [value];
}
