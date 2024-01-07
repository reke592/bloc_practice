/// common contracts for domain repositories implementing domain events reaction
abstract class DomainEvents<T> {
  /// listen to emitted domain events
  Stream<T> getDomainEvents();

  /// push domain event for other logic to trigger chain reaction
  void pushDomainEvent(T event);
}
