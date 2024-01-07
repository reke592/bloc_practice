import 'dart:async';

import 'package:ale/src/commons/enums/bloc_mutation.dart';
import 'package:ale/src/features/recipe/data/models/food_recipe_model.dart';
import 'package:ale/src/features/recipe/domain/entities/food_recipe.dart';
import 'package:ale/src/features/recipe/domain/recipe_domain_event.dart';
import 'package:ale/src/features/recipe/domain/repositories/food_recipe_repository.dart';
import 'package:ale/src/features/recipe/domain/usecases/delete_recepies.dart';
import 'package:ale/src/features/recipe/domain/usecases/get_all_recipes.dart';
import 'package:ale/src/features/recipe/domain/usecases/save_recipe.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'recipe_list_event.dart';
part 'recipe_list_state.dart';

class RecipeListBloc extends Bloc<RecipeListEvent, RecipeListState> {
  RecipeListBloc({
    required FoodRecipeRepository repo,
    required this.getAllRecipes,
    required this.saveRecipe,
    required this.deleteRecepies,
  })  : _repo = repo,
        super(const RecipeListState()) {
    on<LoadFoodRecipes>(_onLoadFoodRecipes);
    on<NewRecipe>(_onNewRecipe);
    on<SelectItem>(_onSelectItem);
    on<ClearSelected>(_onClearSelected);
    on<DeleteSelected>(_onDeleteSelected);
    on<ReplaceExistingItem>(_onReplaceExistingItem);
    _domainEventListener = _repo.getDomainEvents().listen((event) {
      if (event is RecipeDetailsUpdated && state.action is! NewRecipe) {
        add(ReplaceExistingItem(event.value as FoodRecipeModel));
      } else {
        // TODO: optimize
        add(const LoadFoodRecipes());
      }
    });
  }

  late final StreamSubscription<RecipeDomainEvent> _domainEventListener;
  final FoodRecipeRepository _repo;
  final GetAllRecipes getAllRecipes;
  final SaveRecipe saveRecipe;
  final DeleteRecepies deleteRecepies;

  @override
  Future<void> close() async {
    await _domainEventListener.cancel();
    return super.close();
  }

  FutureOr<void> _onLoadFoodRecipes(
    LoadFoodRecipes event,
    Emitter<RecipeListState> emit,
  ) async {
    emit(state.loading(event));
    final result = await getAllRecipes();
    result.fold(
      (error) => emit(state.failed(event, error.failureMessage)),
      (data) => emit(state.success(event, data.cast<FoodRecipeModel>())),
    );
    // try {
    //   emit(state.loading(event));
    //   final data = await _repo.allRecipes();
    //   emit(state.success(event, data));
    // } catch (error) {
    //   emit(state.failed(event, error));
    //   rethrow;
    // }
  }

  FutureOr<void> _onNewRecipe(
    NewRecipe event,
    Emitter<RecipeListState> emit,
  ) async {
    emit(state.loading(event));
    final result = await saveRecipe(SaveRecipeParam(
      id: null,
      serving: event.servings,
      name: event.name,
      description: event.description,
      steps: const [],
    ));
    result.fold(
      (error) => emit(state.failed(event, error.failureMessage)),
      (data) => emit(
        state.success(
          event,
          List<FoodRecipeModel>.from(state.data)..add(data as FoodRecipeModel),
        ),
      ),
    );
    // try {
    //   emit(state.loading(event));
    //   final result = await _repo.saveRecipe(
    //     FoodRecipe(
    //       name: event.name,
    //       serving: event.servings,
    //       description: event.description,
    //     ),
    //   );
    //   event.onDone(result);
    //   emit(
    //     state.success(
    //       event,
    //       List<FoodRecipe>.from(state.data)..add(result),
    //     ),
    //   );
    // } catch (error) {
    //   emit(state.failed(event, error));
    //   rethrow;
    // }
  }

  FutureOr<void> _onSelectItem(
    SelectItem event,
    Emitter<RecipeListState> emit,
  ) {
    if (event.isSelected) {
      emit(
        state.withSelected(
          event,
          Set.from(state.selected)..add(event.value),
        ),
      );
    } else {
      emit(
        state.withSelected(
          event,
          Set.from(state.selected)..remove(event.value),
        ),
      );
    }
  }

  FutureOr<void> _onClearSelected(
    ClearSelected event,
    Emitter<RecipeListState> emit,
  ) {
    emit(state.withSelected(event, const {}));
  }

  FutureOr<void> _onDeleteSelected(
    DeleteSelected event,
    Emitter<RecipeListState> emit,
  ) async {
    emit(state.loading(event));
    final result = await deleteRecepies(DeleteRecepiesParam(
      state.selected.toList().map((e) => e.id!).toList(),
    ));
    result.fold(
      (error) => emit(state.failed(event, error.failureMessage)),
      (_) {
        final updated = List<FoodRecipeModel>.from(state.data);
        for (var item in state.selected) {
          updated.removeWhere((element) => element.id == item.id);
        }
        for (var item in state.selected) {
          updated.removeWhere((element) => element.id == item.id);
        }
        emit(state.copyWith(
          mutation: BlocMutation.success,
          action: event,
          data: updated,
          selected: const {},
        ));
      },
    );
    // try {
    //   emit(state.loading(event));
    //   await _repo.delete(state.selected.toList());
    //   final updated = List<FoodRecipe>.from(state.data);
    //   for (var item in state.selected) {
    //     updated.removeWhere((element) => element.id == item.id);
    //   }
    //   emit(state.copyWith(
    //     mutation: BlocMutation.success,
    //     action: event,
    //     data: updated,
    //     selected: const {},
    //   ));
    // } catch (error) {
    //   emit(state.failed(event, error));
    // }
  }

  FutureOr<void> _onReplaceExistingItem(
    ReplaceExistingItem event,
    Emitter<RecipeListState> emit,
  ) {
    final updated = List<FoodRecipeModel>.from(state.data);
    final index = updated.indexWhere((element) => element.id == event.value.id);
    if (index > -1) {
      updated[index] = event.value;
      emit(state.success(event, updated));
    }
  }
}
