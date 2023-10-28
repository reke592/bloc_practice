import 'package:bloc_practice/src/common/enums/entity_mutations.dart';
import 'package:equatable/equatable.dart';

abstract class Entity<T> extends Equatable {
  final EntityMutation mutation;
  final T id;
  const Entity({required this.id, required this.mutation});
  bool get isModified => mutation == EntityMutation.modified;
}
