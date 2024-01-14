part of 'edit_cooking_step_bloc.dart';

class EditCookingStepState extends Equatable {
  const EditCookingStepState({
    this.recipe = const FoodRecipeModel.empty(),
    this.data = const CookingStepModel.empty(),
    this.isNew = true,
    this.mutation = BlocMutation.initial,
    this.action,
    this.error,
  });
  final FoodRecipe recipe;
  final CookingStep data;
  final bool isNew;
  final BlocMutation mutation;
  final EditCookingStepEvent? action;
  final Object? error;

  @override
  List<Object?> get props => [data, error, action, mutation];

  bool get isInitial => mutation == BlocMutation.initial;
  bool get isLoading => mutation == BlocMutation.loading;
  bool get isSuccess => mutation == BlocMutation.success;
  bool get isFailure => mutation == BlocMutation.failure;

  EditCookingStepState copyWith({
    required EditCookingStepEvent action,
    required BlocMutation mutation,
    Object? Function()? error,
    FoodRecipe? recipe,
    CookingStep? data,
    bool? isNew,
  }) =>
      EditCookingStepState(
        action: action,
        mutation: mutation,
        isNew: isNew ?? this.isNew,
        error: error != null ? error() : this.error,
        recipe: recipe ?? this.recipe,
        data: data ?? this.data,
      );

  EditCookingStepState loading(EditCookingStepEvent event) => copyWith(
        action: event,
        mutation: BlocMutation.loading,
      );

  EditCookingStepState success(EditCookingStepEvent event) => copyWith(
        action: event,
        mutation: BlocMutation.success,
      );

  EditCookingStepState failed(EditCookingStepEvent event, Object error) =>
      copyWith(
        action: event,
        mutation: BlocMutation.failure,
        error: () => error,
      );

  EditCookingStepState withDuration(
    EditCookingStepEvent event,
    Duration value,
  ) =>
      copyWith(
        action: event,
        mutation: BlocMutation.success,
        data: (data as CookingStepModel).copyWith(duration: value),
      );

  EditCookingStepState withInstruction(
    EditCookingStepEvent event,
    String value,
  ) =>
      copyWith(
        action: event,
        mutation: BlocMutation.success,
        data: (data as CookingStepModel).copyWith(instructions: value),
      );

  EditCookingStepState withIngredients(
    EditCookingStepEvent event,
    List<Ingredient> value,
  ) =>
      copyWith(
        action: event,
        mutation: BlocMutation.success,
        data: (data as CookingStepModel).copyWith(
          ingredients: value.cast<IngredientModel>(),
        ),
      );
}
