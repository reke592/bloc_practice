import 'dart:async';

import 'package:bloc_practice/src/common/enums/bloc_mutations.dart';
import 'package:bloc_practice/src/tickets/domain/base_tickets_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'customer_option_state.dart';

class CustomerOptionCubit extends Cubit<CustomerOptionState> {
  final BaseTicketRepository _repo;
  late final StreamSubscription<List<String>> _loadedCustomers;

  CustomerOptionCubit(BaseTicketRepository repo)
      : _repo = repo,
        super(const CustomerOptionState()) {
    _loadedCustomers = repo.getLoadedCustomers().listen((event) {
      _onSuccess(event);
    });
  }

  @override
  Future<void> close() async {
    await _loadedCustomers.cancel();
    return super.close();
  }

  Future<void> loadList({bool reload = false}) async {
    if (!reload && state.mutation == BlocMutation.success) return;

    emit(state.copyWith(mutation: BlocMutation.loading));

    await _repo.loadCustomers().then(_onSuccess).onError(_handleError);
  }

  void _onSuccess(List<String> options) {
    emit(
      state.copyWith(
        mutation: BlocMutation.success,
        options: options,
        error: () => null,
      ),
    );
  }

  void _handleError(Object error, [StackTrace? stackTrace]) {
    emit(state.copyWith(
      mutation: BlocMutation.error,
      error: () => error,
    ));
    addError(error);
  }
}
