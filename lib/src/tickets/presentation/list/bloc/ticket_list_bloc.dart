import 'dart:async';

import 'package:bloc_practice/src/tickets/domain/base_tickets_repository.dart';
import 'package:bloc_practice/src/tickets/domain/models/ticket.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'ticket_list_event.dart';
part 'ticket_list_state.dart';

typedef _E = Emitter<TicketListState>;

class TicketListBloc extends Bloc<TicketListEvent, TicketListState> {
  final BaseTicketRepository _repo;
  late final StreamSubscription<Ticket> _createdTicket;
  late final StreamSubscription<Ticket> _updatedTicket;

  TicketListBloc(BaseTicketRepository repo)
      : _repo = repo,
        super(const TicketListState()) {
    on<LoadList>(_onLoadList);
    on<CreateNewTicket>(_onCreateNewTicket);
    on<CreatedTicket>(_onCreatedTicket);
    on<UpdatedTicket>(_onUpdatedTicket);
    _createdTicket = repo.getCreated().listen((Ticket data) {
      add(CreatedTicket(data));
    });
    _updatedTicket = repo.getUpdated().listen((Ticket data) {
      add(UpdatedTicket(data));
    });
  }

  @override
  Future<void> close() async {
    await _createdTicket.cancel();
    await _updatedTicket.cancel();
    return super.close();
  }

  _onCreatedTicket(CreatedTicket event, _E emit) {
    emit(
      state.success(
        event,
        List<Ticket>.from(state.tickets)..add(event.data),
      ),
    );
  }

  _onUpdatedTicket(UpdatedTicket event, _E emit) {
    final newList = List<Ticket>.from(state.tickets);
    final index = newList.indexWhere((element) => element.id == event.data.id);
    if (index > -1) {
      newList.removeAt(index);
      newList.insert(index, event.data);
    } else {
      newList.add(event.data);
    }
    emit(state.success(event, newList));
  }

  Future<void> _onLoadList(LoadList event, _E emit) async {
    emit(state.loading(event));
    final result = await _repo.loadTickets().catchError(_onError(event, emit));
    emit(state.success(event, result));
  }

  Future<void> _onCreateNewTicket(CreateNewTicket event, _E emit) async {
    emit(state.success(event, state.tickets));
  }

  Function(Object error, [StackTrace? stackTrace]) _onError<T>(
    TicketListEvent action,
    _E emit,
  ) {
    return (error, [stackTrace]) {
      emit(state.failed(action, error));
    };
  }
}
