import 'package:ale/src/core/typedefs.dart';
import 'package:ale/src/core/usecase.dart';
import 'package:ale/src/features/recipe/domain/entities/food_recipe.dart';
import 'package:ale/src/features/recipe/domain/recipe_domain_event.dart';
import 'package:ale/src/features/recipe/domain/repositories/food_recipe_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class SaveCookingStepParam extends Equatable {
  const SaveCookingStepParam({
    required this.recipeId,
    required this.number,
    required this.duration,
    required this.ingredients,
    required this.instructions,
    required this.active,
    required this.isNew,
  });

  final int recipeId;
  final int number;
  final Duration duration;
  final List<Ingredient> ingredients;
  final String instructions;
  final bool active;
  final bool isNew;

  @override
  List<Object?> get props => [
        recipeId,
        number,
        duration,
        ingredients,
        instructions,
        active,
        isNew,
      ];
}

class SaveCookingStep
    extends UsecaseWithParam<CookingStep, SaveCookingStepParam> {
  SaveCookingStep(this._repo);

  final FoodRecipeRepository _repo;

  @override
  ResultFuture<CookingStep> call(SaveCookingStepParam param) async {
    final result = await _repo.saveCookingStep(
      recipeId: param.recipeId,
      number: param.number,
      duration: param.duration,
      ingredients: param.ingredients,
      instructions: param.instructions,
      active: param.active,
    );
    return result.fold(
      Left.new,
      (data) {
        _repo.pushDomainEvent(
          RecipeStepsUpdated(
            recipeId: param.recipeId,
            value: data,
            isNew: param.isNew,
          ),
        );
        return Right(data);
      },
    );
  }
}
