import 'package:ale/src/core/typedefs.dart';
import 'package:ale/src/core/usecase.dart';
import 'package:ale/src/features/recipe/domain/repositories/food_recipe_repository.dart';
import 'package:equatable/equatable.dart';

class DeleteRecepiesParam extends Equatable {
  final List<int> ids;
  const DeleteRecepiesParam(this.ids);
  @override
  List<Object?> get props => ids;
}

class DeleteRecepies extends UsecaseWithParam<void, DeleteRecepiesParam> {
  DeleteRecepies(this._repo);

  final FoodRecipeRepository _repo;

  @override
  ResultFuture<void> call(DeleteRecepiesParam param) {
    return _repo.delete(param.ids);
  }
}
