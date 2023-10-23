import 'package:bloc_practice/src/common/exceptions/record_not_found.dart';
import 'package:bloc_practice/src/tickets/domain/base_tickets_repository.dart';
import 'package:bloc_practice/src/tickets/domain/models/ticket.dart';
import 'package:bloc_practice/src/tickets/domain/models/ticket_history.dart';
import 'package:bloc_practice/src/tickets/domain/models/ticket_status.dart';

/// for testing purpose
class TicketsMemoryRepository extends BaseTicketRepository {
  final List<Ticket> _tickets = [];
  final Map<TicketId, List<TicketHistory>> _history = {};
  final List<TicketStatus> _statuses = [
    TicketStatus(name: 'Open'),
    TicketStatus(name: 'For Development'),
    TicketStatus(name: 'On Development'),
    TicketStatus(name: 'For Testing'),
    TicketStatus(name: 'On Testing'),
    TicketStatus(name: 'For Verification'),
    TicketStatus(name: 'For Merge Feature'),
    TicketStatus(name: 'Merged Feature'),
    TicketStatus(name: 'Closed'),
  ];

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
        mutation: TicketStates.initial,
        id: TicketId(
          value: _tickets.length + 1,
          isTemporary: false,
        ),
      );
      _tickets.add(record);
      return record;
    });
  }

  @override
  Future<List<Ticket>> loadTickets() async {
    return await Future.delayed(
      const Duration(seconds: 1),
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
        final updated = data.copyWith(mutation: TicketStates.initial);
        _tickets[index] = updated;
        return updated;
      },
    );
  }

  @override
  Future<List<TicketHistory>> loadTicketHistory(TicketId refId) async {
    return await Future.delayed(const Duration(seconds: 1), () {
      if (refId.isTemporary) return [];
      return List<TicketHistory>.from(_history[refId] ?? []);
    });
  }

  @override
  Future<List<TicketStatus>> loadTicketStatuses() async {
    return await Future.delayed(
      const Duration(seconds: 1),
      () => List<TicketStatus>.from(_statuses),
    );
  }

  @override
  Future<Ticket> loadTicketDetails(TicketId id) async {
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
}
