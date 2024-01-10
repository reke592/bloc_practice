part of 'edit_cooking_step_bloc.dart';

sealed class EditCookingStepEvent extends Equatable {
  const EditCookingStepEvent();

  @override
  List<Object?> get props => [];
}

class SetEditCookingStepViewModel extends EditCookingStepEvent {
  final FoodRecipe recipe;
  final CookingStep step;
  final bool isNew;
  const SetEditCookingStepViewModel({
    required this.recipe,
    required this.step,
    required this.isNew,
  });
  @override
  List<Object?> get props => [recipe, step, isNew];
}

class ChangeDuration extends EditCookingStepEvent {
  final int? hours;
  final int? minutes;
  final int? seconds;
  const ChangeDuration({
    this.hours,
    this.minutes,
    this.seconds,
  });
  @override
  List<Object?> get props => [hours, minutes, seconds];
}

class ChangeInstruction extends EditCookingStepEvent {
  final String value;
  const ChangeInstruction(this.value);
  @override
  List<Object> get props => [value];
}

class AddIngredient extends EditCookingStepEvent {
  final Ingredient value;
  const AddIngredient(this.value);
  @override
  List<Object> get props => [value];
}

class UpdateIngredient extends EditCookingStepEvent {
  final Ingredient oldValue;
  final Ingredient newValue;
  const UpdateIngredient({required this.oldValue, required this.newValue});
  @override
  List<Object> get props => [oldValue, newValue];
}

class RemoveIngredient extends EditCookingStepEvent {
  final Ingredient value;
  const RemoveIngredient(this.value);
  @override
  List<Object> get props => [value];
}

/// soft delete
class DeleteStep extends EditCookingStepEvent {}

class SaveChanges extends EditCookingStepEvent {}
