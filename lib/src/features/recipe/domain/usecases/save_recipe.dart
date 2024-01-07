import 'package:ale/src/core/typedefs.dart';
import 'package:ale/src/core/usecase.dart';
import 'package:ale/src/features/recipe/domain/entities/food_recipe.dart';
import 'package:ale/src/features/recipe/domain/recipe_domain_event.dart';
import 'package:ale/src/features/recipe/domain/repositories/food_recipe_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class SaveRecipeParam extends Equatable {
  const SaveRecipeParam({
    required this.id,
    required this.serving,
    required this.name,
    required this.description,
    required this.steps,
  });

  final int? id;
  final int serving;
  final String name;
  final String description;
  final List<CookingStep> steps;

  @override
  List<Object?> get props => [
        id,
        serving,
        name,
        description,
        steps,
      ];
}

class SaveRecipe extends UsecaseWithParam<FoodRecipe, SaveRecipeParam> {
  SaveRecipe(this._repo);

  final FoodRecipeRepository _repo;

  @override
  ResultFuture<FoodRecipe> call(SaveRecipeParam param) async {
    final result = await _repo.saveRecipe(
      id: param.id,
      serving: param.serving,
      name: param.name,
      description: param.description,
      steps: param.steps,
    );
    return result.fold(
      (error) => Left(error),
      (data) {
        _repo.pushDomainEvent(RecipeDetailsUpdated(data));
        return Right(data);
      },
    );
  }
}
