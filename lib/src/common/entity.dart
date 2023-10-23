import 'package:equatable/equatable.dart';

abstract class Entity<T> extends Equatable {
  final T id;
  const Entity({required this.id});
  bool get isModified;
}
