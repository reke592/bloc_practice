import 'package:bloc_practice/src/common/entity.dart';
import 'package:bloc_practice/src/common/entity_id.dart';

enum TicketHistoryStates {
  initial,
  modified,
}

class TicketHistoryId extends EntityId<int> {
  TicketHistoryId({
    required super.value,
    required super.isTemporary,
  });
}

class TicketHistory extends Entity<TicketHistoryId> {
  final TicketHistoryStates mutation;
  final String action;
  final String createdBy;
  final String assignedTo;
  final DateTime createdAt;
  final bool deleted;

  const TicketHistory({
    this.mutation = TicketHistoryStates.initial,
    required super.id,
    required this.action,
    required this.createdBy,
    required this.assignedTo,
    required this.createdAt,
    this.deleted = false,
  });

  @override
  List<Object?> get props => [
        id,
        action,
        createdBy,
        assignedTo,
        createdAt,
        deleted,
        mutation,
      ];

  @override
  bool get isModified => mutation == TicketHistoryStates.modified;

  TicketHistory copyWith({
    required TicketHistoryStates mutation,
    String? action,
    String? createdBy,
    String? assignedTo,
    DateTime? createdAt,
    bool? deleted,
  }) =>
      TicketHistory(
        mutation: mutation,
        id: id,
        action: action ?? this.action,
        createdBy: createdBy ?? this.createdBy,
        assignedTo: assignedTo ?? this.assignedTo,
        createdAt: createdAt ?? this.createdAt,
        deleted: deleted ?? this.deleted,
      );

  TicketHistory delete() => copyWith(
        mutation: TicketHistoryStates.modified,
        deleted: true,
      );

  TicketHistory setAction(String action) => copyWith(
        mutation: TicketHistoryStates.modified,
        action: action,
      );

  TicketHistory assignTo(String assignedTo) => copyWith(
        mutation: TicketHistoryStates.modified,
        assignedTo: assignedTo,
      );
}
