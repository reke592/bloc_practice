import 'dart:async';

import 'package:ale/src/commons/enums/bloc_mutation.dart';
import 'package:ale/src/features/recipe/data/models/cooking_step_model.dart';
import 'package:ale/src/features/recipe/data/models/food_recipe_model.dart';
import 'package:ale/src/features/recipe/data/models/ingredient_model.dart';
import 'package:ale/src/features/recipe/domain/entities/food_recipe.dart';
import 'package:ale/src/features/recipe/domain/repositories/food_recipe_repository.dart';
import 'package:ale/src/features/recipe/domain/usecases/delete_cooking_step.dart';
import 'package:ale/src/features/recipe/domain/usecases/save_cooking_step.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

part 'edit_cooking_step_event.dart';
part 'edit_cooking_step_state.dart';

class EditCookingStepBloc
    extends Bloc<EditCookingStepEvent, EditCookingStepState> {
  EditCookingStepBloc({
    required FoodRecipeRepository repo,
    required this.saveCookingStep,
    required this.deleteCookingStep,
  }) : super(const EditCookingStepState()) {
    on<ChangeDuration>(_onChangeDuration, transformer: (events, mapper) {
      return events
          .debounceTime(const Duration(milliseconds: 300))
          .asyncExpand(mapper);
    });
    on<ChangeInstruction>(_onChangeInstruction, transformer: (events, mapper) {
      return events
          .debounceTime(const Duration(milliseconds: 300))
          .asyncExpand(mapper);
    });
    on<SetEditCookingStepViewModel>(_onEditCookingStepViewModel);
    on<AddIngredient>(_onAddIngredient);
    on<RemoveIngredient>(_onRemoveIngredient);
    on<UpdateIngredient>(_onUpdateIngredient);
    on<SaveChanges>(_onSaveChanges);
    on<DeleteStep>(_onDeleteStep);
  }

  final SaveCookingStep saveCookingStep;
  final DeleteCookingStep deleteCookingStep;

  FutureOr<void> _onChangeDuration(
    ChangeDuration event,
    Emitter<EditCookingStepState> emit,
  ) {
    final [hours, minutes, seconds] = state.data.duration
        .toString()
        .split('.')[0] // ignore millis
        .split(':')
        .map(int.parse)
        .toList();
    emit(
      state.withDuration(
        event,
        Duration(
          hours: event.hours ?? hours,
          minutes: event.minutes ?? minutes,
          seconds: event.seconds ?? seconds,
        ),
      ),
    );
  }

  FutureOr<void> _onChangeInstruction(
    ChangeInstruction event,
    Emitter<EditCookingStepState> emit,
  ) {
    emit(state.withInstruction(event, event.value));
  }

  FutureOr<void> _onAddIngredient(
    AddIngredient event,
    Emitter<EditCookingStepState> emit,
  ) {
    emit(
      state.withIngredients(
        event,
        List.from(state.data.ingredients)..add(event.value),
      ),
    );
  }

  FutureOr<void> _onRemoveIngredient(
    RemoveIngredient event,
    Emitter<EditCookingStepState> emit,
  ) {
    emit(
      state.withIngredients(
        event,
        List<IngredientModel>.from(state.data.ingredients)
          ..removeWhere((element) => element.name == event.value.name),
      ),
    );
  }

  FutureOr<void> _onUpdateIngredient(
    UpdateIngredient event,
    Emitter<EditCookingStepState> emit,
  ) {
    final index = state.data.ingredients
        .indexWhere((element) => element == event.oldValue);
    if (index > -1) {
      final updated = List<Ingredient>.from(state.data.ingredients);
      updated[index] = event.newValue;
      emit(state.withIngredients(event, updated));
    }
  }

  FutureOr<void> _onSaveChanges(
    SaveChanges event,
    Emitter<EditCookingStepState> emit,
  ) async {
    emit(state.loading(event));
    final result = await saveCookingStep(SaveCookingStepParam(
      recipeId: state.recipe.id!,
      number: state.data.number,
      duration: state.data.duration,
      ingredients: state.data.ingredients,
      instructions: state.data.instructions,
      active: state.data.active,
      isNew: state.isNew,
    ));
    result.fold(
      (error) => emit(state.failed(event, error.failureMessage)),
      (_) {
        emit(state.success(event));
      },
    );
  }

  FutureOr<void> _onDeleteStep(
    DeleteStep event,
    Emitter<EditCookingStepState> emit,
  ) async {
    emit(state.loading(event));
    final result = await deleteCookingStep(DeleteCookingStepParam(
      recipeId: state.recipe.id!,
      number: state.data.number,
    ));
    result.fold(
      (error) => emit(state.failed(event, error.message)),
      (_) => emit(state.success(event)),
    );
  }

  FutureOr<void> _onEditCookingStepViewModel(
    SetEditCookingStepViewModel event,
    Emitter<EditCookingStepState> emit,
  ) {
    emit(state.copyWith(
      action: event,
      mutation: BlocMutation.success,
      recipe: event.recipe,
      data: event.step,
      isNew: event.isNew,
    ));
  }
}
