part of 'ticket_list_bloc.dart';

enum TicketListStates {
  initial,
  loading,
  success,
  error,
  focused,
}

class TicketListState extends Equatable {
  final TicketListEvent? action;
  final List<Ticket> tickets;
  final TicketId? focusedId;
  final Object? error;
  final TicketListStates mutation;

  const TicketListState({
    this.action,
    this.tickets = const [],
    this.focusedId,
    this.error,
    this.mutation = TicketListStates.initial,
  });

  @override
  List<Object?> get props => [
        action,
        tickets,
        focusedId,
        error,
        mutation,
      ];

  TicketListState copyWith({
    required TicketListEvent action,
    required TicketListStates mutation,
    List<Ticket>? tickets,
    TicketId? Function()? focusedId,
    Object? Function()? error,
  }) =>
      TicketListState(
        action: action,
        mutation: mutation,
        tickets: tickets ?? this.tickets,
        focusedId: focusedId != null ? focusedId() : this.focusedId,
        error: error != null ? error() : this.error,
      );

  TicketListState loading(TicketListEvent action) => copyWith(
        action: action,
        mutation: TicketListStates.loading,
      );

  TicketListState success(TicketListEvent action, List<Ticket> tickets) =>
      copyWith(
        action: action,
        mutation: TicketListStates.success,
        tickets: tickets,
      );

  TicketListState withFocus(TicketListEvent action, TicketId focusedId) =>
      copyWith(
        action: action,
        mutation: TicketListStates.focused,
        focusedId: () => focusedId,
      );

  TicketListState failed(TicketListEvent action, Object error) => copyWith(
        action: action,
        mutation: TicketListStates.error,
        error: () => error,
      );
}
