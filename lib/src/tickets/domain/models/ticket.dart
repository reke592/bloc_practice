import 'package:bloc_practice/src/common/entity.dart';
import 'package:bloc_practice/src/common/entity_id.dart';
import 'package:bloc_practice/src/tickets/domain/models/ticket_history.dart';
import 'package:flutter/widgets.dart';

enum TicketStates {
  initial,
  modified,
}

class TicketId extends EntityId<int> {
  TicketId({
    required super.value,
    required super.isTemporary,
  });

  factory TicketId.temporary(int value) => TicketId(
        value: value,
        isTemporary: true,
      );
}

@immutable
class Ticket extends Entity<TicketId> {
  final TicketStates mutation;
  final String client;
  final String title;
  final String narration;
  final String status;

  final String? category;
  final DateTime? created;
  final List<TicketHistory> history;

  const Ticket({
    required super.id,
    this.mutation = TicketStates.initial,
    this.client = '',
    this.title = '',
    this.narration = '',
    this.status = '',
    this.category,
    this.created,
    this.history = const [],
  });

  @override
  List<Object?> get props => [
        id,
        title,
        narration,
        status,
        history,
        mutation,
      ];

  @override
  bool get isModified => mutation == TicketStates.modified;

  Ticket copyWith({
    required TicketStates mutation,
    TicketId? id,
    String? client,
    String? title,
    String? narration,
    String? status,
    List<TicketHistory>? history,
  }) =>
      Ticket(
        mutation: mutation,
        id: id ?? this.id,
        client: client ?? this.client,
        title: title ?? this.title,
        narration: narration ?? this.narration,
        status: status ?? this.status,
        history: history ?? this.history,
      );

  Ticket setClient(String client) => copyWith(
        mutation: TicketStates.modified,
        client: client,
      );

  Ticket setTitle(String title) => copyWith(
        mutation: TicketStates.modified,
        title: title,
      );

  Ticket setNarration(String narration) => copyWith(
        mutation: TicketStates.modified,
        narration: narration,
      );

  Ticket setStatus(String status) => copyWith(
        mutation: TicketStates.modified,
        status: status,
      );

  Ticket withHistory(List<TicketHistory> history) => copyWith(
        mutation: mutation,
        history: history,
      );

  Ticket addHistory(TicketHistory value) => copyWith(
        mutation: TicketStates.modified,
        history: List<TicketHistory>.from(history)..add(value),
      );

  Ticket removeHistory(TicketHistory value) {
    final index = history.indexWhere((element) => element.id == value.id);
    if (index > -1) {
      final list = List<TicketHistory>.from(history);
      if (value.id.isTemporary) {
        list.removeAt(index);
      } else {
        list[index] = value.delete();
      }
      return copyWith(
        mutation: TicketStates.modified,
        history: list,
      );
    } else {
      return this;
    }
  }
}
