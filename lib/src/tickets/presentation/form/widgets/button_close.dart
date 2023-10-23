import 'package:bloc_practice/src/tickets/presentation/form/bloc/ticket_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ButtonClose extends StatelessWidget {
  const ButtonClose({super.key});

  @override
  Widget build(BuildContext context) {
    return BackButton(
      onPressed: () {
        context.read<TicketFormBloc>().add(const FormClose());
      },
    );
  }
}
