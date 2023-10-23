class EntityId<T> {
  final T value;
  final bool isTemporary;

  EntityId({required this.value, required this.isTemporary});

  @override
  operator ==(other) {
    return other is EntityId<T>
        ? value.hashCode == other.value.hashCode
        : false;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => isTemporary ? 'temp-$value' : '$value';
}
