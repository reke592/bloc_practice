import 'dart:convert';

import 'package:bloc_practice/src/common/enums/entity_mutations.dart';
import 'package:bloc_practice/src/common/exceptions/record_not_found.dart';
import 'package:bloc_practice/src/tickets/domain/base_tickets_repository.dart';
import 'package:bloc_practice/src/tickets/domain/models/ticket.dart';
import 'package:bloc_practice/src/tickets/domain/models/ticket_history.dart';
import 'package:bloc_practice/src/tickets/domain/models/ticket_status.dart';
import 'package:flutter/services.dart';

/// for testing purpose
class TicketsMemoryRepository extends BaseTicketRepository {
  final List<String> _companies = [];
  final List<Ticket> _tickets = [];
  final Map<TicketId, List<TicketHistory>> _history = {};
  final List<TicketStatus> _statuses = [];

  @override
  void dispose() {
    _tickets.clear();
    _history.clear();
    _statuses.clear();
    super.dispose();
  }

  @override
  Future<Ticket> createTicket(Ticket data) async {
    return await Future.delayed(const Duration(seconds: 1), () {
      final record = data.copyWith(
        mutation: EntityMutation.initial,
        id: TicketId(
          value: _tickets.length + 1,
          isTemporary: false,
        ),
        created: DateTime.now(),
      );
      _tickets.add(record);
      return record;
    });
  }

  @override
  Future<List<Ticket>> loadTickets() async {
    if (_tickets.isEmpty) {
      final data = await rootBundle
          .loadString('resource/data/tickets/stub_tickets.json');
      _tickets.addAll(List<Map<String, dynamic>>.from(jsonDecode(data))
          .map<Ticket>(Ticket.fromJson));
    }
    return await Future.delayed(
      const Duration(milliseconds: 1500),
      () => List<Ticket>.from(_tickets),
    );
  }

  @override
  Future<Ticket> updateTicket(Ticket data) async {
    return await Future.delayed(
      const Duration(seconds: 1),
      () {
        final index = _tickets.indexWhere((record) => record.id == data.id);
        if (index < 0) throw Exception('Not found');
        final updated = data.copyWith(mutation: EntityMutation.initial);
        _tickets[index] = updated;
        return updated;
      },
    );
  }

  @override
  Future<List<TicketHistory>> loadTicketHistory(TicketId id) async {
    return await Future.delayed(const Duration(seconds: 1), () {
      if (id.isTemporary) return [];
      return List<TicketHistory>.from(_history[id] ?? []);
    });
  }

  @override
  Future<List<TicketStatus>> loadTicketStatuses() async {
    if (_statuses.isEmpty) {
      final data = await rootBundle
          .loadString('resource/data/tickets/stub_statuses.json');
      _statuses.addAll(List<Map<String, dynamic>>.from(jsonDecode(data))
          .map<TicketStatus>(TicketStatus.fromJson));
    }
    return await Future.delayed(
      const Duration(seconds: 1),
      () {
        final result = List<TicketStatus>.from(_statuses);
        loadedTicketStatus.add(result);
        return result;
      },
    );
  }

  @override
  Future<Ticket> loadTicketDetails(TicketId id) async {
    if (_tickets.isEmpty) {
      final data = await rootBundle
          .loadString('resource/data/tickets/stub_tickets.json');
      _tickets.addAll(List<Map<String, dynamic>>.from(jsonDecode(data))
          .map<Ticket>(Ticket.fromJson));
    }
    return await Future.delayed(
      const Duration(seconds: 1),
      () {
        try {
          return _tickets.firstWhere((element) => element.id == id);
        } catch (_) {
          throw RecordNotFoundException();
        }
      },
    );
  }

  @override
  Future<List<String>> loadCustomers() async {
    if (_companies.isEmpty) {
      final data = await rootBundle
          .loadString('resource/data/tickets/stub_companies.json');
      _companies.addAll(List<String>.from(jsonDecode(data)));
    }
    return await Future.delayed(
      const Duration(seconds: 1),
      () {
        final results = List<String>.from(_companies);
        loadedCustomers.add(results);
        return results;
      },
    );
  }

  @override
  Future<List<Ticket>> loadMentionableTickets(String pattern) async {
    if (_tickets.isEmpty) {
      final data = await rootBundle
          .loadString('resource/data/tickets/stub_tickets.json');
      _tickets.addAll(List<Map<String, dynamic>>.from(jsonDecode(data))
          .map<Ticket>(Ticket.fromJson));
    }
    await Future.delayed(const Duration(seconds: 1));
    final regex = RegExp(pattern, caseSensitive: false, dotAll: false);
    return List<Ticket>.from(_tickets.where((element) =>
        regex.hasMatch(element.title) ||
        regex.hasMatch(element.customer) ||
        regex.hasMatch(element.narration))).toList();
  }
}
