part of 'status_option_cubit.dart';

class StatusOptionState extends Equatable {
  final BlocMutation mutation;
  final List<TicketStatus> options;
  final Object? error;

  const StatusOptionState({
    this.mutation = BlocMutation.initial,
    this.options = const [],
    this.error,
  });

  bool get isInitial => mutation == BlocMutation.initial;
  bool get isLoading => mutation == BlocMutation.loading;
  bool get isSuccess => mutation == BlocMutation.success;
  bool get isError => mutation == BlocMutation.error;

  StatusOptionState copyWith({
    required BlocMutation mutation,
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
