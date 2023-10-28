part of 'ticket_form_bloc.dart';

sealed class TicketFormEvent extends Equatable {
  const TicketFormEvent();

  @override
  List<Object> get props => [];
}

sealed class _Sequential extends TicketFormEvent {
  const _Sequential();
}

class LoadDetails extends _Sequential {
  final TicketId id;
  const LoadDetails(this.id);
}

class LoadTicketHistory extends _Sequential {
  final TicketId id;
  const LoadTicketHistory(this.id);
}

class UpdateTicketStatus extends TicketFormEvent {
  final String value;
  const UpdateTicketStatus(this.value);
  @override
  List<Object> get props => [value];
}

class UpdateTitle extends TicketFormEvent {
  final String value;
  const UpdateTitle(this.value);
  @override
  List<Object> get props => [value];
}

class UpdateNarration extends TicketFormEvent {
  final String value;
  const UpdateNarration(this.value);
  @override
  List<Object> get props => [value];
}

class TagCustomer extends TicketFormEvent {
  final String value;
  const TagCustomer(this.value);
  @override
  List<Object> get props => [value];
}

class FormClose extends TicketFormEvent {
  final bool discard;
  const FormClose([this.discard = false]);
  @override
  List<Object> get props => [discard];
}

class FormSave extends TicketFormEvent {}

class FormEdit extends TicketFormEvent {}
