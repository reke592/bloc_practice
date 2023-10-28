import 'dart:async';
import 'dart:developer';

import 'package:bloc_practice/src/tickets/domain/models/ticket_history.dart';
import 'package:bloc_practice/src/tickets/domain/models/ticket_status.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/subjects.dart';

import 'models/ticket.dart';

abstract class BaseTicketRepository extends ChangeNotifier {
  final createdTicket = PublishSubject<Ticket>();
  final updatedTicket = PublishSubject<Ticket>();
  final loadedTicketStatus = BehaviorSubject<List<TicketStatus>>();
  final loadedCustomers = BehaviorSubject<List<String>>();

  Stream<Ticket> getCreated() => createdTicket.stream.asBroadcastStream();
  Stream<Ticket> getUpdated() => updatedTicket.stream.asBroadcastStream();
  Stream<List<TicketStatus>> getLoadedTicketStatus() =>
      loadedTicketStatus.stream.asBroadcastStream();
  Stream<List<String>> getLoadedCustomers() =>
      loadedCustomers.stream.asBroadcastStream();

  @mustCallSuper
  @override
  FutureOr<void> dispose() async {
    await createdTicket.close();
    await updatedTicket.close();
    await loadedTicketStatus.close();
    await loadedCustomers.close();
    super.dispose();
    log('$runtimeType disposed');
  }

  Future<List<Ticket>> loadTickets();
  Future<Ticket> loadTicketDetails(TicketId id);
  Future<Ticket> createTicket(Ticket data);
  Future<Ticket> updateTicket(Ticket data);
  Future<List<TicketHistory>> loadTicketHistory(TicketId id);
  Future<List<TicketStatus>> loadTicketStatuses();
  Future<List<String>> loadCustomers();
}
