import 'dart:async';

import 'package:bloc_practice/src/common/mixins/filter_data_properties.dart';
import 'package:bloc_practice/src/tickets/domain/base_tickets_repository.dart';
import 'package:bloc_practice/src/tickets/domain/models/ticket.dart';
import 'package:bloc_practice/src/tickets/domain/models/ticket_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'ticket_list_event.dart';
part 'ticket_list_state.dart';

typedef _E = Emitter<TicketListState>;

class TicketListBloc extends Bloc<TicketListEvent, TicketListState>
    with FilterDataProperties<Ticket> {
  final BaseTicketRepository _repo;
  late final StreamSubscription<Ticket> _createdTicket;
  late final StreamSubscription<Ticket> _updatedTicket;
  late final StreamSubscription<List<String>> _loadedCustomers;
  late final StreamSubscription<List<TicketStatus>> _loadedTicketStatus;

  TicketListBloc(BaseTicketRepository repo)
      : _repo = repo,
        super(const TicketListState()) {
    on<LoadList>(_onLoadList);
    on<CreateNewTicket>(_onCreateNewTicket);
    on<CreatedTicket>(_onCreatedTicket);
    on<UpdatedTicket>(_onUpdatedTicket);
    on<FilteredList>(_onFilteredList);
    _createdTicket = repo.getCreated().listen((Ticket data) {
      add(CreatedTicket(data));
    });
    _updatedTicket = repo.getUpdated().listen((Ticket data) {
      add(UpdatedTicket(data));
    });
    _loadedCustomers = repo.getLoadedCustomers().listen((data) {
      useTagOptions(
        name: 'Customers',
        options: data.toSet(),
        matchString: (record) => record.customer,
      );
    });
    _loadedTicketStatus = repo.getLoadedTicketStatus().listen((data) {
      useTagOptions(
        name: 'Ticket Status',
        options: data.map((e) => e.name).toSet(),
        matchString: (record) => record.status,
      );
    });
  }

  @override
  Future<void> close() async {
    await _createdTicket.cancel();
    await _updatedTicket.cancel();
    await _loadedCustomers.cancel();
    await _loadedTicketStatus.cancel();
    return super.close();
  }

  @override
  void onChange(Change<TicketListState> change) {
    super.onChange(change);
    if (change.nextState.isSuccess) {
      switch (change.nextState.action.runtimeType) {
        case LoadList:
        case CreatedTicket:
        case UpdatedTicket:
          applyFilter();
      }
    }
  }

  @override
  FutureOr<List<Ticket>> get filterReference => state.tickets;

  @override
  String forSearch(record) =>
      '${record.customer};${record.title};${record.status}';

  @override
  String get forSearchHint => 'Customer | Title | Status';

  @override
  void onApplyFilter(filtered) {
    add(FilteredList(filtered));
  }

  @override
  Map<String, int Function(Ticket a, Ticket b)> initialSortOptions() => {
        'Date Created': (a, b) => a.created!.compareTo(b.created!),
        'Customer Name': (a, b) => a.customer.compareTo(b.customer),
      };

  _onCreatedTicket(CreatedTicket event, _E emit) {
    final result = List<Ticket>.from(state.tickets)..add(event.data);
    emit(state.success(event, result));
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
    try {
      emit(state.loading(event));
      final result = await _repo.loadTickets();
      emit(state.success(event, result));
    } catch (error) {
      emit(state.failed(event, error));
      rethrow;
    }
  }

  Future<void> _onCreateNewTicket(CreateNewTicket event, _E emit) async {
    emit(state.success(event, state.tickets));
  }

  void _onFilteredList(FilteredList event, _E emit) {
    emit(state.withFilteredList(event));
  }
}
