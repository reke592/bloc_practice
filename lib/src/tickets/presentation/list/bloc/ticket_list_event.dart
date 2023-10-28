part of 'ticket_list_bloc.dart';

sealed class TicketListEvent {
  const TicketListEvent();
}

class LoadList extends TicketListEvent {}

class CreateNewTicket extends TicketListEvent {}

class CreatedTicket extends TicketListEvent {
  final Ticket data;
  const CreatedTicket(this.data);
}

class UpdatedTicket extends TicketListEvent {
  final Ticket data;
  const UpdatedTicket(this.data);
}

class FilteredList extends TicketListEvent {
  final List<Ticket> data;
  const FilteredList(this.data);
}
