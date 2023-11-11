import 'package:flutter/material.dart';
import 'package:mention_field/src/mention_configuration.dart';
import 'package:mention_field/src/mention_field_controller.dart';
import 'package:mention_field/src/mention_range.dart';

/// {@template mention_field}
/// [TextField] with mention features
/// {@endtemplate}
class MentionField extends StatefulWidget {
  /// {@macro mention_triggers}
  final Map<String, MentionConfiguration> mentionTriggers;

  /// on init hook to get a reference of controller instance
  final void Function(MentionFieldController controller)? onInit;

  /// {@macro on_mention_updated}
  final void Function(String value, List<MentionRange> mentions)?
      onMentionsUpdated;

  /// [TextField] properties
  final void Function(String value)? onChanged;

  /// [TextField] properties
  final void Function()? onTap;

  /// [TextField] properties
  final void Function(PointerDownEvent)? onTapOutside;

  /// [TextField] properties
  final void Function(String)? onSubmitted;

  /// [TextField] properties
  final void Function()? onEditingComplete;

  /// [TextField] properties
  final InputDecoration? decoration;

  /// {@macro mentions}
  final List<MentionRange> mentions;

  /// initial text value for [MentionFieldController]
  final String? text;

  /// [TextField] properties
  final int? maxLines;

  /// [TextField] properties
  final int? maxLength;

  /// [TextField] properties
  final bool readOnly;

  /// [TextField] properties
  final bool autofocus;

  /// loading indicator widget while waiting for suggestion snapshot
  final Widget loadingIndicator;

  /// debounce duration to throtle call for suggestion datasource
  final Duration debounce;

  /// max height constraint for suggestion box
  final double suggestionMaxHeight;

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
    this.maxLines,
    this.maxLength,
    this.readOnly = false,
    this.autofocus = false,
    this.loadingIndicator = const LinearProgressIndicator(),
    this.debounce = const Duration(milliseconds: 200),
    this.suggestionMaxHeight = 200,
  });

  @override
  State<MentionField> createState() => _MentionFieldState();
}

class _MentionFieldState extends State<MentionField> {
  late final MentionFieldController _controller;
  Future<List<dynamic>> _mentionable = Future.value([]);

  @override
  void initState() {
    _controller = MentionFieldController(
      text: widget.text,
      mentions: widget.mentions,
      mentionTriggers: widget.mentionTriggers,
      debounce: widget.debounce,
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
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          decoration: widget.decoration,
          minLines: 1,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          readOnly: widget.readOnly,
          autofocus: widget.autofocus,
          // focusNode: _controller.focusNode,
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
        if (_controller.isMentioning && _controller.activeConfig != null)
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: widget.suggestionMaxHeight),
            child: FutureBuilder(
              future: _mentionable,
              builder: (context, snapshot) {
                final data = snapshot.data ?? [];
                return Column(
                  children: [
                    if (snapshot.connectionState == ConnectionState.waiting)
                      widget.loadingIndicator,
                    Expanded(
                      child: ListView.builder(
                        itemCount: data.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return _controller.activeConfig!
                              .cast()
                              .listItemBuilder(
                                context,
                                data[index],
                                _controller.addMention,
                              );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
      ],
    );
  }
}
