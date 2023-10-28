part of 'ticket_form_bloc.dart';

class TicketFormState extends Equatable {
  final FormModes mode;
  final Ticket data;
  final TicketFormEvent? action;
  final Object? error;
  final BlocMutation mutation;

  const TicketFormState({
    required this.mode,
    required this.data,
    this.action,
    this.error,
    this.mutation = BlocMutation.initial,
  });

  @override
  List<Object?> get props => [
        mode,
        data,
        action,
        error,
        mutation,
      ];

  bool get isInitial => mutation == BlocMutation.initial;
  bool get isLoading => mutation == BlocMutation.loading;
  bool get isSuccess => mutation == BlocMutation.success;
  bool get isError => mutation == BlocMutation.error;

  TicketFormState copyWith({
    required TicketFormEvent action,
    required BlocMutation mutation,
    Ticket? data,
    Object? Function()? error,
    FormModes? mode,
  }) =>
      TicketFormState(
        action: action,
        mutation: mutation,
        data: data ?? this.data,
        error: error != null ? error() : this.error,
        mode: mode ?? this.mode,
      );

  /// common
  TicketFormState loading(TicketFormEvent action) => copyWith(
        action: action,
        mutation: BlocMutation.loading,
      );

  /// common
  TicketFormState success(TicketFormEvent action, Ticket data) => copyWith(
        action: action,
        mutation: BlocMutation.success,
        data: data,
      );

  /// common
  TicketFormState failed(TicketFormEvent action, Object error) => copyWith(
        action: action,
        mutation: BlocMutation.error,
        error: () => error,
      );

  TicketFormState withMode(TicketFormEvent action, FormModes mode) => copyWith(
        action: action,
        mutation: BlocMutation.success,
        mode: mode,
      );
}
