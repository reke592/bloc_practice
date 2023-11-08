part of 'ticket_form_bloc.dart';

class TicketFormState extends Equatable {
  final FormModes mode;
  final Ticket data;
  final TicketFormEvent? action;
  final Object? error;
  final BlocMutation mutation;
  final int mentionPrefixStart;
  final String mentionPrefix;
  final TextEditingController? editingController;

  const TicketFormState({
    required this.mode,
    required this.data,
    this.action,
    this.error,
    this.mutation = BlocMutation.initial,
    this.mentionPrefixStart = 0,
    this.mentionPrefix = '',
    this.editingController,
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
    int? mentionPrefixStart,
    String? mentionPrefix,
    TextEditingController? Function()? editingController,
  }) =>
      TicketFormState(
        action: action,
        mutation: mutation,
        data: data ?? this.data,
        error: error != null ? error() : this.error,
        mode: mode ?? this.mode,
        mentionPrefix: mentionPrefix ?? this.mentionPrefix,
        mentionPrefixStart: mentionPrefixStart ?? this.mentionPrefixStart,
        editingController: editingController != null
            ? editingController()
            : this.editingController,
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
