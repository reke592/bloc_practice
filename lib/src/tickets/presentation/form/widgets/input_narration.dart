import 'package:bloc_practice/src/common/enums/form_modes.dart';
import 'package:bloc_practice/src/common/extensions/shimmer_effect_on_widget.dart';
import 'package:bloc_practice/src/tickets/domain/base_tickets_repository.dart';
import 'package:bloc_practice/src/tickets/domain/models/ticket.dart';
import 'package:bloc_practice/src/tickets/presentation/form/bloc/ticket_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mention_field/mention_field.dart';

class InputNarration extends StatelessWidget {
  const InputNarration({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TicketFormBloc>();
    return BlocBuilder<TicketFormBloc, TicketFormState>(
      buildWhen: (_, current) =>
          current.action is LoadDetails || current.action is FormEdit,
      builder: (context, state) {
        final readOnly = state.mode == FormModes.view;
        return Column(
          children: [
            MentionField(
              text: state.data.narration,
              readOnly: readOnly,
              maxLines: 5,
              decoration: const InputDecoration(label: Text('Narration')),
              mentions: state.data.mentions,
              onInit: (controller) {
                controller = controller;
              },
              mentionTriggers: {
                '#': MentionConfiguration<Ticket>(
                  dataSource: context
                      .read<BaseTicketRepository>()
                      .loadMentionableTickets,
                  extraValue: (value) => {
                    'id': value.id,
                  },
                  listItemBuilder: (context, value, mention) {
                    return ListTile(
                      title: Text(value.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(value.narration),
                          Text(value.customer),
                        ],
                      ),
                      onTap: () {
                        mention(value);
                      },
                    );
                  },
                  onTap: (mention) {
                    context.pushNamed(
                      'view ticket',
                      pathParameters: {
                        'id': mention.extra['id'].toString(),
                      },
                    );
                  },
                ),
              },
              onMentionsUpdated: (value, mentions) {
                context.read<TicketFormBloc>()
                  ..add(UpdateNarration(value))
                  ..add(MentionsUpdated(mentions));
              },
              onChanged: !readOnly
                  ? (value) {
                      bloc.add(UpdateNarration(value));
                    }
                  : null,
            ).addShimmer(state.isLoading),
          ],
        );
      },
    );
  }
}
