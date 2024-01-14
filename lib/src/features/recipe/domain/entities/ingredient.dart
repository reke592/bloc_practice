part of 'food_recipe.dart';

class Ingredient extends Equatable {
  const Ingredient({
    required this.name,
    required this.amount,
    required this.unit,
  });
  final String name;
  final double amount;
  final String unit;

  @override
  List<Object?> get props => [name, amount, unit];
}
