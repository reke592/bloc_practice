import 'package:bloc_practice/src/tickets/domain/base_tickets_repository.dart';
import 'package:bloc_practice/src/tickets/domain/models/ticket_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'status_option_state.dart';

class StatusOptionCubit extends Cubit<StatusOptionState> {
  final BaseTicketRepository _repo;

  StatusOptionCubit(BaseTicketRepository repo)
      : _repo = repo,
        super(const StatusOptionState());

  Future<void> loadList({bool reload = false}) async {
    if (!reload && state.mutation == StatusOptionStates.success) return;

    emit(state.copyWith(mutation: StatusOptionStates.loading));

    await _repo.loadTicketStatuses().then(_onSuccess).onError(_handleError);
  }

  void _onSuccess(List<TicketStatus> options) {
    emit(
      state.copyWith(
        mutation: StatusOptionStates.success,
        options: options,
        error: () => null,
      ),
    );
  }

  void _handleError(Object error, [StackTrace? stackTrace]) {
    emit(state.copyWith(
      mutation: StatusOptionStates.error,
      error: () => error,
    ));
  }
}
