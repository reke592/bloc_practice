part of 'recipe_view_bloc.dart';

class RecipeViewState extends Equatable {
  final FoodRecipe data;
  final Set<String> completed;
  final int? adjustedServing;
  final RecipeViewEvent? action;
  final BlocMutation mutation;
  final Object? error;

  const RecipeViewState({
    this.data = const FoodRecipeModel.empty(),
    this.adjustedServing,
    this.completed = const {},
    this.mutation = BlocMutation.initial,
    this.action,
    this.error,
  });

  bool get isInitial => mutation == BlocMutation.initial;
  bool get isLoading => mutation == BlocMutation.loading;
  bool get isSuccess => mutation == BlocMutation.success;
  bool get isFailure => mutation == BlocMutation.failure;

  @override
  List<Object?> get props => [
        data,
        completed,
        adjustedServing,
        error,
        action,
        mutation,
      ];

  RecipeViewState copyWith({
    required RecipeViewEvent action,
    required BlocMutation mutation,
    FoodRecipe? data,
    Set<String>? completed,
    int? Function()? adjustedServing,
    Object? Function()? error,
  }) =>
      RecipeViewState(
        action: action,
        mutation: mutation,
        data: data ?? this.data,
        completed: completed ?? this.completed,
        adjustedServing:
            adjustedServing != null ? adjustedServing() : this.adjustedServing,
        error: error != null ? error() : this.error,
      );

  RecipeViewState loading(RecipeViewEvent event) => copyWith(
        action: event,
        mutation: BlocMutation.loading,
      );

  RecipeViewState success(RecipeViewEvent event, FoodRecipe data) => copyWith(
        action: event,
        mutation: BlocMutation.success,
        data: data,
      );

  RecipeViewState failure(RecipeViewEvent event, Object error) => copyWith(
        action: event,
        mutation: BlocMutation.failure,
      );

  RecipeViewState withCompletedSteps(
    RecipeViewEvent event,
    Set<String> completed,
  ) =>
      copyWith(
        action: event,
        mutation: BlocMutation.success,
        completed: completed,
      );

  RecipeViewState withAdjustedServing(RecipeViewEvent event, int? value) =>
      copyWith(
        action: event,
        mutation: BlocMutation.success,
        adjustedServing: () => value,
      );
}
