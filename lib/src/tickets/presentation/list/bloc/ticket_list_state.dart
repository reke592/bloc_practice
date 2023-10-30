part of 'ticket_list_bloc.dart';

enum BlocMutation {
  initial,
  loading,
  success,
  error,
}

class TicketListState extends Equatable {
  final TicketListEvent? action;
  final List<Ticket> tickets;
  final TicketId? focusedId;
  final Object? error;
  final BlocMutation mutation;

  const TicketListState({
    this.action,
    this.tickets = const [],
    this.focusedId,
    this.error,
    this.mutation = BlocMutation.initial,
  });

  bool get isInitial => mutation == BlocMutation.initial;
  bool get isLoading => mutation == BlocMutation.loading;
  bool get isSuccess => mutation == BlocMutation.success;
  bool get isError => mutation == BlocMutation.error;

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
    required BlocMutation mutation,
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
        mutation: BlocMutation.loading,
      );

  TicketListState success(TicketListEvent action, List<Ticket> tickets) =>
      copyWith(
        action: action,
        mutation: BlocMutation.success,
        tickets: tickets,
      );

  TicketListState failed(TicketListEvent action, Object error) => copyWith(
        action: action,
        mutation: BlocMutation.error,
        error: () => error,
      );

  TicketListState withFilteredList(TicketListEvent action) => copyWith(
        action: action,
        mutation: BlocMutation.success,
      );
}
