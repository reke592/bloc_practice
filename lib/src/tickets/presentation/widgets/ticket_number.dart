import 'package:bloc_practice/src/tickets/domain/models/ticket.dart';
import 'package:flutter/material.dart';

class TicketNumber extends StatelessWidget {
  final TicketId id;
  final TextStyle? style;

  const TicketNumber({
    super.key,
    required this.id,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return id.isTemporary
        ? Text('$id', style: style)
        : Text('[${id.value.toString().padLeft(6, '0')}]', style: style);
  }
}
