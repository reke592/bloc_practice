import 'package:bloc_practice/src/common/entity.dart';
import 'package:bloc_practice/src/common/entity_id.dart';
import 'package:bloc_practice/src/common/enums/entity_mutations.dart';
import 'package:bloc_practice/src/tickets/domain/models/ticket_history.dart';
import 'package:flutter/widgets.dart';
import 'package:mention_field/mention_field.dart';

class TicketId extends EntityId<int> {
  const TicketId({
    required super.value,
    required super.isTemporary,
  });

  factory TicketId.temporary(int value) => TicketId(
        value: value,
        isTemporary: true,
      );

  factory TicketId.fromString(String value) => TicketId(
        value: int.parse(value),
        isTemporary: false,
      );
}

@immutable
class Ticket extends Entity<TicketId> implements Mentionable {
  final String customer;
  final String title;
  final String narration;
  final String status;

  final String? category;
  final DateTime? created;
  final List<TicketHistory> history;
  final List<MentionRange> mentions;

  const Ticket({
    required super.id,
    super.mutation = EntityMutation.initial,
    this.customer = '',
    this.title = '',
    this.narration = '',
    this.status = '',
    this.category,
    this.created,
    this.history = const [],
    this.mentions = const [],
  });

  @override
  List<Object?> get props => [
        id,
        title,
        narration,
        status,
        history,
        mentions,
        mutation,
      ];

  @override
  bool get isModified => mutation == EntityMutation.modified;

  Ticket copyWith({
    required EntityMutation mutation,
    TicketId? id,
    String? customer,
    String? title,
    String? narration,
    String? status,
    String? category,
    DateTime? created,
    List<TicketHistory>? history,
    List<MentionRange>? mentions,
  }) =>
      Ticket(
        mutation: mutation,
        id: id ?? this.id,
        customer: customer ?? this.customer,
        title: title ?? this.title,
        narration: narration ?? this.narration,
        status: status ?? this.status,
        category: category ?? this.category,
        created: created ?? this.created,
        history: history ?? this.history,
        mentions: mentions ?? this.mentions,
      );

  factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
        id: TicketId(value: json['id'], isTemporary: json['new'] == true),
        category: json['category'],
        created: DateTime.tryParse('${json['created']}'),
        customer: json['customer'],
        narration: json['narration'],
        status: json['status'],
        title: json['title'],
        mentions: List<Map<String, dynamic>>.from(json['mentions'] ?? [])
            .map(MentionRange.fromJson)
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'new': id.isTemporary,
        'id': id.value,
        'category': category,
        'created': created?.toIso8601String(),
        'customer': customer,
        'narration': narration,
        'status': status,
        'title': title,
        'mentions': mentions.map((e) => e.toJson()).toList()
      };

  Ticket setClient(String client) => copyWith(
        mutation: EntityMutation.modified,
        customer: client,
      );

  Ticket setTitle(String title) => copyWith(
        mutation: EntityMutation.modified,
        title: title,
      );

  Ticket setNarration(String narration) => copyWith(
        mutation: EntityMutation.modified,
        narration: narration,
      );

  Ticket withMentions(List<MentionRange> value) => copyWith(
        mutation: EntityMutation.modified,
        mentions: value,
      );

  Ticket tagCustomer(String customer) => copyWith(
        mutation: EntityMutation.modified,
        customer: customer,
      );

  Ticket setStatus(String status) => copyWith(
        mutation: EntityMutation.modified,
        status: status,
      );

  Ticket withHistory(List<TicketHistory> history) => copyWith(
        mutation: mutation,
        history: history,
      );

  Ticket addHistory(TicketHistory value) => copyWith(
        mutation: EntityMutation.modified,
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
        mutation: EntityMutation.modified,
        history: list,
      );
    } else {
      return this;
    }
  }

  @override
  String get mentionableText => id.toString().padLeft(6, '0');
}
