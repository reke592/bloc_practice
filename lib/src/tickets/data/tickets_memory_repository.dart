import 'package:bloc_practice/src/common/enums/entity_mutations.dart';
import 'package:bloc_practice/src/common/exceptions/record_not_found.dart';
import 'package:bloc_practice/src/tickets/domain/base_tickets_repository.dart';
import 'package:bloc_practice/src/tickets/domain/models/ticket.dart';
import 'package:bloc_practice/src/tickets/domain/models/ticket_history.dart';
import 'package:bloc_practice/src/tickets/domain/models/ticket_status.dart';

/// for testing purpose
class TicketsMemoryRepository extends BaseTicketRepository {
  final List<String> _companies = [
    'ABC Inc.',
    'DEF Alliance',
    'GHI Machineries',
    'JK Laboratories',
    'MiNO Corp.',
  ];
  final List<Ticket> _tickets = [
    Ticket(
      id: const TicketId(value: 1, isTemporary: false),
      customer: 'ABC Inc.',
      title: 'Email notification enhancement',
      narration: 'sent email queue must have data retention of atleast 30d.',
      status: 'For Development',
      created: DateTime.parse('2023-10-01'),
    ),
    Ticket(
      id: const TicketId(value: 2, isTemporary: false),
      customer: 'MiNO Corp.',
      title: 'Logs integration',
      narration: 'Legacy system logs to roll-up in new system',
      status: 'On Testing',
      created: DateTime.parse('2023-10-02'),
    ),
    Ticket(
      id: const TicketId(value: 3, isTemporary: false),
      customer: 'GHI Machineries',
      title: 'Additional analytics chart for Manpower Allocation',
      narration:
          'Request for additional analytics chart to balance Manpower Allocation in multiple site locations',
      status: 'For Verification',
      created: DateTime.parse('2023-10-03'),
    ),
  ];
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
    return await Future.delayed(
      const Duration(seconds: 1),
      () {
        final results = List<String>.from(_companies);
        loadedCustomers.add(results);
        return results;
      },
    );
  }
}
