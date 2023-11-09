import 'dart:async';

import 'package:bloc_practice/src/common/enums/bloc_mutations.dart';
import 'package:bloc_practice/src/tickets/domain/base_tickets_repository.dart';
import 'package:bloc_practice/src/tickets/domain/models/ticket_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'status_option_state.dart';

class StatusOptionCubit extends Cubit<StatusOptionState> {
  final BaseTicketRepository _repo;
  late final StreamSubscription<List<TicketStatus>> _loadedTicketStatus;

  StatusOptionCubit(BaseTicketRepository repo)
      : _repo = repo,
        super(const StatusOptionState()) {
    _loadedTicketStatus = repo.getLoadedTicketStatus().listen(_onSuccess);
  }

  @override
  Future<void> close() async {
    await _loadedTicketStatus.cancel();
    return super.close();
  }

  Future<void> loadList({bool reload = false}) async {
    if (!reload && state.mutation == BlocMutation.success) return;

    emit(state.copyWith(mutation: BlocMutation.loading));

    await _repo.loadTicketStatuses().then(_onSuccess).onError(_handleError);
  }

  void _onSuccess(List<TicketStatus> options) {
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
