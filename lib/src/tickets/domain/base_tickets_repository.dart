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

  Stream<Ticket> getCreated() => createdTicket.stream.asBroadcastStream();
  Stream<Ticket> getUpdated() => updatedTicket.stream.asBroadcastStream();

  @mustCallSuper
  @override
  FutureOr<void> dispose() async {
    await createdTicket.close();
    await updatedTicket.close();
    super.dispose();
    log('$runtimeType disposed');
  }

  Future<List<Ticket>> loadTickets();
  Future<Ticket> loadTicketDetails(TicketId id);
  Future<Ticket> createTicket(Ticket data);
  Future<Ticket> updateTicket(Ticket data);
  Future<List<TicketHistory>> loadTicketHistory(TicketId refId);
  Future<List<TicketStatus>> loadTicketStatuses();
}
