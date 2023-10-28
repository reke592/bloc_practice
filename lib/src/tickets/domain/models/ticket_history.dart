import 'package:bloc_practice/src/common/entity.dart';
import 'package:bloc_practice/src/common/entity_id.dart';
import 'package:bloc_practice/src/common/enums/entity_mutations.dart';

class TicketHistoryId extends EntityId<int> {
  TicketHistoryId({
    required super.value,
    required super.isTemporary,
  });
}

class TicketHistory extends Entity<TicketHistoryId> {
  final String action;
  final String createdBy;
  final String assignedTo;
  final DateTime createdAt;
  final bool deleted;

  const TicketHistory({
    super.mutation = EntityMutation.initial,
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

  TicketHistory copyWith({
    required EntityMutation mutation,
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
        mutation: EntityMutation.modified,
        deleted: true,
      );

  TicketHistory setAction(String action) => copyWith(
        mutation: EntityMutation.modified,
        action: action,
      );

  TicketHistory assignTo(String assignedTo) => copyWith(
        mutation: EntityMutation.modified,
        assignedTo: assignedTo,
      );
}
