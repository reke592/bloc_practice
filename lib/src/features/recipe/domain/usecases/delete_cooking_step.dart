import 'package:ale/src/core/typedefs.dart';
import 'package:ale/src/core/usecase.dart';
import 'package:ale/src/features/recipe/domain/recipe_domain_event.dart';
import 'package:ale/src/features/recipe/domain/repositories/food_recipe_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class DeleteCookingStepParam extends Equatable {
  const DeleteCookingStepParam({
    required this.recipeId,
    required this.number,
    this.permanent = false,
  });

  final int recipeId;
  final int number;
  final bool permanent;

  @override
  List<Object?> get props => [recipeId, number, permanent];
}

class DeleteCookingStep extends UsecaseWithParam<void, DeleteCookingStepParam> {
  DeleteCookingStep(this._repo);

  final FoodRecipeRepository _repo;

  @override
  ResultFuture<void> call(DeleteCookingStepParam param) async {
    final result = await _repo.deleteStep(
      recipeId: param.recipeId,
      number: param.number,
      permanent: param.permanent,
    );
    return result.fold(
      (error) => Left(error),
      (data) {
        _repo.pushDomainEvent(
          RecipeStepsRemoved(
            recipeId: param.recipeId,
            number: param.number,
            isPermanent: param.permanent,
          ),
        );
        return Right(data);
      },
    );
  }
}
