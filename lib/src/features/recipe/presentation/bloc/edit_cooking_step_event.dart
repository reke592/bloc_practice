part of 'edit_cooking_step_bloc.dart';

sealed class EditCookingStepEvent extends Equatable {
  const EditCookingStepEvent();

  @override
  List<Object?> get props => [];
}

class SetEditCookingStepViewModel extends EditCookingStepEvent {
  const SetEditCookingStepViewModel({
    required this.recipe,
    required this.step,
    required this.isNew,
  });
  final FoodRecipe recipe;
  final CookingStep step;
  final bool isNew;
  @override
  List<Object?> get props => [recipe, step, isNew];
}

class ChangeDuration extends EditCookingStepEvent {
  const ChangeDuration({
    this.hours,
    this.minutes,
    this.seconds,
  });
  final int? hours;
  final int? minutes;
  final int? seconds;
  @override
  List<Object?> get props => [hours, minutes, seconds];
}

class ChangeInstruction extends EditCookingStepEvent {
  const ChangeInstruction(this.value);
  final String value;
  @override
  List<Object> get props => [value];
}

class AddIngredient extends EditCookingStepEvent {
  const AddIngredient(this.value);
  final Ingredient value;
  @override
  List<Object> get props => [value];
}

class UpdateIngredient extends EditCookingStepEvent {
  const UpdateIngredient({required this.oldValue, required this.newValue});
  final Ingredient oldValue;
  final Ingredient newValue;
  @override
  List<Object> get props => [oldValue, newValue];
}

class RemoveIngredient extends EditCookingStepEvent {
  const RemoveIngredient(this.value);
  final Ingredient value;
  @override
  List<Object> get props => [value];
}

/// soft delete
class DeleteStep extends EditCookingStepEvent {}

class SaveChanges extends EditCookingStepEvent {}
