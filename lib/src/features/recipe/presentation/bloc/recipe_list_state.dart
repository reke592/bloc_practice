part of 'recipe_list_bloc.dart';

class RecipeListState extends Equatable {
  final List<FoodRecipe> data;
  final RecipeListEvent? action;
  final BlocMutation mutation;
  final Object? error;
  final Set<FoodRecipe> selected;

  const RecipeListState({
    this.data = const [],
    this.mutation = BlocMutation.initial,
    this.action,
    this.error,
    this.selected = const {},
  });

  @override
  List<Object?> get props => [data, selected.length, error, action, mutation];

  bool get isInitial => mutation == BlocMutation.initial;
  bool get isLoading => mutation == BlocMutation.loading;
  bool get isSuccess => mutation == BlocMutation.success;
  bool get isFailure => mutation == BlocMutation.failure;

  RecipeListState copyWith({
    required BlocMutation mutation,
    required RecipeListEvent action,
    List<FoodRecipe>? data,
    Object? Function()? error,
    Set<FoodRecipe>? selected,
  }) =>
      RecipeListState(
        data: data ?? this.data,
        action: action,
        mutation: mutation,
        error: error != null ? error() : this.error,
        selected: selected ?? this.selected,
      );

  RecipeListState actionEvent(RecipeListEvent event) => copyWith(
        mutation: BlocMutation.success,
        action: event,
      );

  RecipeListState loading(RecipeListEvent event) => copyWith(
        mutation: BlocMutation.loading,
        action: event,
      );

  RecipeListState success(RecipeListEvent event, List<FoodRecipe> data) =>
      copyWith(
        mutation: BlocMutation.success,
        action: event,
        data: data,
      );

  RecipeListState failed(RecipeListEvent event, Object error) => copyWith(
        mutation: BlocMutation.failure,
        action: event,
        error: () => error,
      );

  RecipeListState withSelected(
    RecipeListEvent event,
    Set<FoodRecipe> value,
  ) =>
      copyWith(
        mutation: BlocMutation.success,
        action: event,
        selected: value,
      );
}
