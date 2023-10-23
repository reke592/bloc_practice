part of 'status_option_cubit.dart';

enum StatusOptionStates {
  initial,
  loading,
  success,
  error,
}

class StatusOptionState extends Equatable {
  final StatusOptionStates mutation;
  final List<TicketStatus> options;
  final Object? error;

  const StatusOptionState({
    this.mutation = StatusOptionStates.initial,
    this.options = const [],
    this.error,
  });

  StatusOptionState copyWith({
    required StatusOptionStates mutation,
    List<TicketStatus>? options,
    Object? Function()? error,
  }) =>
      StatusOptionState(
        mutation: mutation,
        options: options ?? this.options,
        error: error != null ? error() : this.error,
      );

  @override
  List<Object?> get props => [
        options,
        error,
        mutation,
      ];
}
