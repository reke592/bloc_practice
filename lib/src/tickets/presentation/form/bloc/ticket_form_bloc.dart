import 'dart:async';

import 'package:bloc_practice/src/common/enums/bloc_mutations.dart';
import 'package:bloc_practice/src/common/enums/form_modes.dart';
import 'package:bloc_practice/src/common/exceptions/form_dirty_exception.dart';
import 'package:bloc_practice/src/tickets/domain/base_tickets_repository.dart';
import 'package:bloc_practice/src/tickets/domain/models/ticket.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:mention_field/mention_field.dart';

part 'ticket_form_event.dart';
part 'ticket_form_state.dart';

typedef _E = Emitter<TicketFormState>;

class TicketFormBloc extends Bloc<TicketFormEvent, TicketFormState> {
  final BaseTicketRepository _repo;

  TicketFormBloc({
    required BaseTicketRepository repo,
    required FormModes mode,
    required TicketId id,
  })  : _repo = repo,
        super(TicketFormState(
          mode: mode,
          data: Ticket(id: id),
          mutation:
              id.isTemporary ? BlocMutation.initial : BlocMutation.loading,
        )) {
    on<UpdateTicketStatus>(_onUpdateTicketStatus);
    on<UpdateTitle>(_onUpdateTitle);
    on<UpdateNarration>(_onUpdateNarration);
    on<TagCustomer>(_onTagCompany);
    on<FormSave>(_onFormSave);
    on<FormClose>(_onFormClose);
    on<FormEdit>(_onFormEdit);
    on<_Sequential>((event, emit) {
      if (event is LoadDetails) return _onLoadDetails(event, emit);
      if (event is LoadTicketHistory) return _onLoadTicketHistory(event, emit);
    }, transformer: sequential());
    on<MentionsUpdated>(_onMentionsUpdated);
  }

  _onMentionsUpdated(MentionsUpdated event, _E emit) {
    emit(state.success(event, state.data.withMentions(event.value)));
  }

  Future<void> _onLoadDetails(LoadDetails event, _E emit) async {
    if (event.id.isTemporary) return;
    try {
      emit(state.loading(event));
      final data = await _repo.loadTicketDetails(event.id);
      emit(state.success(event, data));
    } catch (error) {
      emit(state.failed(event, error));
      rethrow;
    }
  }

  _onLoadTicketHistory(LoadTicketHistory event, _E emit) async {
    if (event.id.isTemporary) return;
    try {
      emit(state.loading(event));
      final result = await _repo.loadTicketHistory(event.id);
      emit(state.success(
        event,
        state.data.withHistory(result),
      ));
    } catch (error) {
      emit(state.failed(event, error));
      rethrow;
    }
  }

  _onFormEdit(FormEdit event, _E emit) {
    emit(state.withMode(event, FormModes.edit));
  }

  _onUpdateTitle(UpdateTitle event, _E emit) {
    emit(state.success(event, state.data.setTitle(event.value)));
  }

  _onUpdateNarration(UpdateNarration event, _E emit) {
    emit(state.success(event, state.data.setNarration(event.value)));
  }

  _onTagCompany(TagCustomer event, _E emit) {
    emit(state.success(event, state.data.tagCustomer(event.value)));
  }

  Future<void> _onFormSave(FormSave event, _E emit) async {
    try {
      emit(state.loading(event));
      final result = (state.data.id.isTemporary)
          ? await _repo.createTicket(state.data)
          : await _repo.updateTicket(state.data);
      if (state.data.id.isTemporary) {
        _repo.createdTicket.add(result);
      } else {
        _repo.updatedTicket.add(result);
      }
      emit(state.success(event, result));
    } catch (error) {
      emit(state.failed(event, error));
      rethrow;
    }
  }

  Future<void> _onFormClose(FormClose event, _E emit) async {
    if (state.data.isModified && !event.discard) {
      emit(state.failed(event, FormDirtyException()));
    } else {
      emit(state.success(event, state.data));
    }
  }

  _onUpdateTicketStatus(UpdateTicketStatus event, _E emit) async {
    emit(state.success(
      event,
      state.data.setStatus(event.value),
    ));
  }
}
