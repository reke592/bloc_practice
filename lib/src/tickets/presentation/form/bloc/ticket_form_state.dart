part of 'ticket_form_bloc.dart';

enum TicketFormStates {
  initial,
  loading,
  success,
  error,
}

class TicketFormState extends Equatable {
  final FormModes mode;
  final Ticket data;
  final TicketFormEvent? action;
  final Object? error;
  final TicketFormStates mutation;

  const TicketFormState({
    required this.mode,
    required this.data,
    this.action,
    this.error,
    this.mutation = TicketFormStates.initial,
  });

  @override
  List<Object?> get props => [
        mode,
        data,
        action,
        error,
        mutation,
      ];

  TicketFormState copyWith({
    required TicketFormEvent action,
    required TicketFormStates mutation,
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

  TicketFormState loading(TicketFormEvent action) => copyWith(
        action: action,
        mutation: TicketFormStates.loading,
      );

  TicketFormState success(TicketFormEvent action, Ticket data) => copyWith(
        action: action,
        mutation: TicketFormStates.success,
        data: data,
      );

  TicketFormState failed(TicketFormEvent action, Object error) => copyWith(
        action: action,
        mutation: TicketFormStates.error,
        error: () => error,
      );

  TicketFormState withMode(TicketFormEvent action, FormModes mode) => copyWith(
        action: action,
        mutation: TicketFormStates.success,
        mode: mode,
      );
}
