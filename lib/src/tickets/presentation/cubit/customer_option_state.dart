part of 'customer_option_cubit.dart';

class CustomerOptionState extends Equatable {
  final BlocMutation mutation;
  final List<String> options;
  final Object? error;

  const CustomerOptionState({
    this.mutation = BlocMutation.initial,
    this.options = const [],
    this.error,
  });

  bool get isInitial => mutation == BlocMutation.initial;
  bool get isLoading => mutation == BlocMutation.loading;
  bool get isSuccess => mutation == BlocMutation.success;
  bool get isError => mutation == BlocMutation.error;

  CustomerOptionState copyWith({
    required BlocMutation mutation,
    List<String>? options,
    Object? Function()? error,
  }) =>
      CustomerOptionState(
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
