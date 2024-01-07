import 'package:ale/src/core/failure.dart';
import 'package:ale/src/core/typedefs.dart';
import 'package:ale/src/features/recipe/data/datasources/recipe_data_source.dart';
import 'package:ale/src/features/recipe/data/models/cooking_step_model.dart';
import 'package:ale/src/features/recipe/data/models/ingredient_model.dart';
import 'package:ale/src/features/recipe/domain/entities/food_recipe.dart';
import 'package:ale/src/features/recipe/domain/recipe_domain_event.dart';
import 'package:ale/src/features/recipe/domain/repositories/food_recipe_repository.dart';
import 'package:dartz/dartz.dart';

import 'package:rxdart/rxdart.dart';

class FoodRecipeRepositoryImplementation extends FoodRecipeRepository {
  FoodRecipeRepositoryImplementation(this._dataSource);
  final RecipeDataSource _dataSource;
  late final _domainEvents = PublishSubject<RecipeDomainEvent>();

  @override
  void pushDomainEvent(RecipeDomainEvent event) {
    _domainEvents.add(event);
  }

  @override
  Stream<RecipeDomainEvent> getDomainEvents() =>
      _domainEvents.stream.asBroadcastStream();

  @override
  ResultFuture<List<FoodRecipe>> allRecipes() async {
    try {
      final result = await _dataSource.allRecipes();
      return Right(result);
    } on ApiFailure catch (_) {
      rethrow;
    } catch (error) {
      return Left(UnknownFailure(message: '$error', statusCode: 505));
    }
  }

  @override
  ResultFuture<FoodRecipe> saveRecipe({
    required int? id,
    required int serving,
    required String name,
    required String description,
    required List<CookingStep> steps,
  }) async {
    try {
      final result = await _dataSource.saveRecipe(
        id: id,
        serving: serving,
        name: name,
        description: description,
        steps: steps.cast<CookingStepModel>(),
      );
      return Right(result);
    } on ApiFailure catch (_) {
      rethrow;
    } catch (error) {
      return Left(UnknownFailure(message: '$error', statusCode: 505));
    }
  }

  @override
  ResultVoid delete(List<int> ids) async {
    try {
      final result = await _dataSource.delete(ids);
      return Right(result);
    } on ApiFailure catch (_) {
      rethrow;
    } catch (error) {
      return Left(UnknownFailure(message: '$error', statusCode: 505));
    }
  }

  @override
  ResultFuture<CookingStep> saveCookingStep({
    required int recipeId,
    required int number,
    required Duration duration,
    required List<Ingredient> ingredients,
    required String instructions,
    required bool active,
  }) async {
    try {
      final result = await _dataSource.saveCookingStep(
        recipeId: recipeId,
        number: number,
        duration: duration,
        ingredients: ingredients.cast<IngredientModel>(),
        instructions: instructions,
        active: active,
      );
      return Right(result);
    } on ApiFailure catch (_) {
      rethrow;
    } catch (error) {
      return Left(UnknownFailure(message: '$error', statusCode: 505));
    }
  }

  @override
  ResultVoid deleteStep({
    required int recipeId,
    required int number,
    required bool permanent,
  }) async {
    try {
      final result = await _dataSource.deleteStep(
        recipeId: recipeId,
        number: number,
        permanent: permanent,
      );
      return Right(result);
    } on ApiFailure catch (_) {
      rethrow;
    } catch (error) {
      return Left(UnknownFailure(message: '$error', statusCode: 505));
    }
  }
}
