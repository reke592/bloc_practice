import 'dart:async';

import 'package:ale/src/commons/enums/bloc_mutation.dart';
import 'package:ale/src/features/recipe/data/models/cooking_step_model.dart';
import 'package:ale/src/features/recipe/data/models/food_recipe_model.dart';
import 'package:ale/src/features/recipe/domain/entities/food_recipe.dart';
import 'package:ale/src/features/recipe/domain/recipe_domain_event.dart';
import 'package:ale/src/features/recipe/domain/repositories/food_recipe_repository.dart';
import 'package:ale/src/features/recipe/domain/usecases/save_recipe.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

part 'recipe_view_event.dart';
part 'recipe_view_state.dart';

class RecipeViewBloc extends Bloc<RecipeViewEvent, RecipeViewState> {
  RecipeViewBloc({
    required FoodRecipeRepository repo,
    required this.saveRecipe,
  })  : _repo = repo,
        super(const RecipeViewState()) {
    on<SetRecipeViewModel>(_onSetRecipeViewModel);
    on<SetCompletedStep>(_onSetCompletedStep);
    on<ChangeRecipeDetails>(_onChangeRecipeDetails);
    on<AddStep>(_onAddStep);
    on<UpdateStep>(_onUpdateStep);
    on<RemoveStep>(_onRemoveStep);
    on<AdjustServing>(_onAdjustServing, transformer: (events, mapper) {
      return events
          .debounceTime(const Duration(milliseconds: 300))
          .asyncExpand(mapper);
    });
    _domainEventListener = _repo.getDomainEvents().listen((event) {
      if (event is RecipeStepsUpdated) {
        if (event.recipeId == state.data.id) {
          return add(event.isNew
              ? AddStep(event.value as CookingStepModel)
              : UpdateStep(event.value as CookingStepModel));
        }
      }
      if (event is RecipeStepsRemoved) {
        if (event.recipeId == state.data.id) {
          return add(
            event.isPermanent
                ? RemoveStep(event.number)
                : UpdateStep(state.data.steps
                    .cast<CookingStepModel>()
                    .firstWhere((element) => element.number == event.number)
                    .copyWith(active: false)),
          );
        }
      }
    });
  }

  late final StreamSubscription<RecipeDomainEvent> _domainEventListener;
  final FoodRecipeRepository _repo;
  final SaveRecipe saveRecipe;

  @override
  Future<void> close() async {
    await _domainEventListener.cancel();
    return super.close();
  }

  FutureOr<void> _onSetRecipeViewModel(
    SetRecipeViewModel event,
    Emitter<RecipeViewState> emit,
  ) {
    emit(state.copyWith(
      action: event,
      mutation: BlocMutation.success,
      data: event.data,
    ));
  }

  FutureOr<void> _onSetCompletedStep(
    SetCompletedStep event,
    Emitter<RecipeViewState> emit,
  ) {
    final completed = Set<String>.from(state.completed);
    if (event.isCompleted) {
      completed.add(event.value.number.toString());
    } else {
      completed.remove(event.value.number.toString());
    }
    emit(state.withCompletedSteps(event, completed));
  }

  FutureOr<void> _onAdjustServing(
    AdjustServing event,
    Emitter<RecipeViewState> emit,
  ) {
    emit(state.withAdjustedServing(event, event.value));
  }

  FutureOr<void> _onChangeRecipeDetails(
    ChangeRecipeDetails event,
    Emitter<RecipeViewState> emit,
  ) async {
    emit(state.loading(event));
    final result = await saveRecipe(
      SaveRecipeParam(
        id: state.data.id,
        serving: event.servings,
        name: event.name,
        description: event.description,
        steps: state.data.steps.cast<CookingStepModel>(),
      ),
    );
    result.fold(
      (error) => emit(state.failure(event, error.failureMessage)),
      (data) => emit(state.success(event, data)),
    );
  }

  FutureOr<void> _onAddStep(
    AddStep event,
    Emitter<RecipeViewState> emit,
  ) {
    emit(
      state.success(
        event,
        (state.data as FoodRecipeModel).copyWith(
          steps: List.from(state.data.steps)..add(event.value),
        ),
      ),
    );
  }

  FutureOr<void> _onUpdateStep(
    UpdateStep event,
    Emitter<RecipeViewState> emit,
  ) {
    final updated = List<CookingStepModel>.from(state.data.steps);
    final index = state.data.steps
        .indexWhere((element) => element.number == event.value.number);
    if (index > -1) {
      updated[index] = event.value;
      emit(
        state.success(
          event,
          (state.data as FoodRecipeModel).copyWith(steps: updated),
        ),
      );
    }
  }

  FutureOr<void> _onRemoveStep(
    RemoveStep event,
    Emitter<RecipeViewState> emit,
  ) {
    emit(
      state.success(
        event,
        (state.data as FoodRecipeModel).copyWith(
          steps: List.from(state.data.steps)
            ..removeWhere((element) => element.number == event.number),
        ),
      ),
    );
  }
}
