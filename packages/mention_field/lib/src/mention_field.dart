import 'package:flutter/material.dart';
import 'package:mention_field/src/mention_configuration.dart';
import 'package:mention_field/src/mention_field_controller.dart';
import 'package:mention_field/src/mention_range.dart';

/// {@template mention_field}
/// [TextField] with mention features
/// {@endtemplate}
class MentionField extends StatefulWidget {
  final Map<String, MentionConfiguration> mentionTriggers;
  final void Function(MentionFieldController controller)? onInit;
  final void Function(String value, List<MentionRange> mentions)?
      onMentionsUpdated;
  final void Function(String value)? onChanged;
  final void Function()? onTap;
  final void Function(PointerDownEvent)? onTapOutside;
  final void Function(String)? onSubmitted;
  final void Function()? onEditingComplete;
  final InputDecoration? decoration;
  final List<MentionRange> mentions;
  final String? text;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final bool readOnly;
  final bool autofocus;

  /// {@macro mention_field}
  const MentionField({
    super.key,
    required this.mentionTriggers,
    this.onInit,
    this.onMentionsUpdated,
    this.onChanged,
    this.onTap,
    this.onTapOutside,
    this.onSubmitted,
    this.onEditingComplete,
    this.decoration = const InputDecoration(),
    this.mentions = const [],
    this.text,
    this.minLines,
    this.maxLines,
    this.maxLength,
    this.readOnly = false,
    this.autofocus = false,
  });

  @override
  State<MentionField> createState() => _MentionFieldState();
}

class _MentionFieldState extends State<MentionField> {
  late final MentionFieldController _controller;
  List<dynamic> _mentionable = [];

  @override
  void initState() {
    _controller = MentionFieldController(
      text: widget.text,
      mentions: widget.mentions,
      mentionTriggers: widget.mentionTriggers,
      onMentionsUpdated: widget.onMentionsUpdated,
      onMentionTrigger: (mentionKey, mentionable) {
        setState(() {
          _mentionable = mentionable;
        });
      },
    );
    widget.onInit?.call(_controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: widget.decoration,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          readOnly: widget.readOnly,
          autofocus: widget.autofocus,
          focusNode: _controller.focusNode,
          controller: _controller,
          onChanged: widget.onChanged,
          onTap: () {
            _controller.clearMentionSelection();
            widget.onTap?.call();
          },
          onTapOutside: (event) {
            widget.onTapOutside?.call(event);
          },
          onSubmitted: (value) {
            _controller.clearMentionSelection();
            widget.onSubmitted?.call(value);
          },
          onEditingComplete: () {
            _controller.clearMentionSelection();
            widget.onEditingComplete?.call();
          },
        ),
        if (_controller.isMentioning &&
            _mentionable.isNotEmpty &&
            _controller.activeConfig != null)
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              itemCount: _mentionable.length,
              itemBuilder: (context, index) {
                return _controller.activeConfig!.cast().listItemBuilder(
                      context,
                      _mentionable[index],
                      _controller.addMention,
                    );
              },
            ),
          ),
      ],
    );
  }
}
