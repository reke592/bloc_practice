import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mention_field/mention_field.dart';

/// {@template mention_field_controller}
/// controller for [MentionField]
///
/// modified [TextEditingController] to support mentions in [TextField]
/// {@endtemplate}
class MentionFieldController extends TextEditingController {
  final Duration debounce;

  /// focus node to attach in text field widget
  final FocusNode focusNode = FocusNode();

  /// mention text color
  final Color mentionColor;

  /// mention datasource based on String trigger
  final Map<String, MentionConfiguration> mentionTriggers;

  /// receives the [mentionTriggers] result for widget layer to call a [setState].
  final void Function(String trigger, List<dynamic> mentionable)
      onMentionTrigger;

  /// callback to receive updated mention list in controller
  final void Function(String value, List<MentionRange> mentions)?
      onMentionsUpdated;

  /// {@template is_mentioning}
  /// true when collapsed selection is equal to any [mentionTriggers] key.
  /// {@endtemplate}
  bool _isMentioning = false;

  /// {@macro is_mentioning}
  bool get isMentioning => _isMentioning;

  /// {@template mentions}
  /// list of mention position in controller text value
  /// {@endtemplate}
  final List<MentionRange> _mentions;

  /// {@macro mentions}
  List<MentionRange> get mentions => _mentions;

  /// {@template mention_key}
  /// key to call in [mentionTriggers]
  /// {@endtemplate}
  String _mentionKey = '';

  /// {@macro mention_key}
  String get mentionKey => _mentionKey;

  /// {@template mention_start}
  /// text position where the [mentionKey] is triggered
  /// {@endtemplate}
  int _mentionStart = -1;

  /// {@macro mention_start}
  int get mentionStart => _mentionStart;

  /// {@template mention_end}
  /// position of the last character in mention pattern
  /// {@endtemplate}
  int _mentionEnd = -1;

  /// {@macro mention_end}
  int get mentionEnd => _mentionEnd;

  /// throttle call to [mentionTriggers]
  String? _mentionPattern;

  /// to determine changes if append or delete
  int _previousLength = 0;

  /// active mention configuration
  MentionConfiguration? get activeConfig => _activeConfig;
  MentionConfiguration? _activeConfig;

  /// debounce origin request for mentionable list
  Timer? _debouncer;

  MentionFieldController({
    required this.mentionTriggers,
    required this.onMentionTrigger,
    this.debounce = const Duration(milliseconds: 200),
    this.onMentionsUpdated,
    this.mentionColor = Colors.blue,
    List<MentionRange> mentions = const [],
    String? text,
  })  : _mentions = List.from(mentions),
        super.fromValue(
          text != null ? TextEditingValue(text: text) : TextEditingValue.empty,
        );

  @override
  void dispose() {
    _debouncer?.cancel();
    super.dispose();
  }

  /// reset mention selection
  void clearMentionSelection() {
    if (_isMentioning) {
      _isMentioning = false;
      _activeConfig = null;
      _mentionPattern = null;
      _mentionKey = '';
      _mentionStart = -1;
      _mentionEnd = -1;
      onMentionTrigger('', []);
    }
  }

  void addMention(Mentionable value) {
    if (_isMentioning) {
      String mentionableText = value.mentionableText;
      final start = _mentionStart;
      final end = _mentionEnd;
      final mention = MentionRange(
        trigger: _mentionKey,
        start: _mentionStart,
        end: _mentionStart + mentionableText.length,
        text: mentionableText,
        extra: _activeConfig!.cast().extraValue(value),
      );

      clearMentionSelection();
      focusNode.requestFocus();

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        final updated = text.replaceRange(start, end, mentionableText);
        if (_mentions.isNotEmpty) {
          final lengthUpdates = updated.length - text.length;
          _updateMentionPositions(lengthUpdates);
        }
        // append mention data
        _mentions.add(mention);
        // sort mention data for faster substring rendering
        _mentions.sort((a, b) => a.start.compareTo(b.start));
        // update text value
        text = updated;
        // update selection to make sure we focus on the right position
        selection = TextSelection(
          baseOffset: mention.end,
          extentOffset: mention.end,
        );
        onMentionsUpdated?.call(text, _mentions);
      });
    }
  }

  /// remove mention if selection is in range and length updates -1
  void _removeMention(int updates) {
    if (updates < 0) {
      int pos = value.selection.start;
      // debugPrint('-- $runtimeType check mentions to remove at position: $pos');
      _mentions
          .removeWhere((element) => element.start <= pos && element.end >= pos);
      onMentionsUpdated?.call(text, _mentions);
    }
  }

  /// identify mention start
  ///
  /// call mentionTriggers if and only if the selection is collapsed and selection start is greater than the mention start (mention key was not removed)
  /// pass the async result to onMentionTrigger callback
  /// if there was an error fetching the result, callback empty list.
  void _identifyMentionStart(int updates) {
    if (value.text.isNotEmpty &&
        value.selection.isCollapsed &&
        updates > 0 &&
        !_isMentioning) {
      // debugPrint('-- $runtimeType check mention key');
      // only check substring if valuse has valid selection range
      _mentionKey = value.selection.start > -1
          ? value.text.substring(
              value.selection.start - 1,
              value.selection.start,
            )
          : '';

      _isMentioning = mentionTriggers.keys.contains(mentionKey);
      _mentionStart = _isMentioning ? value.selection.start - 1 : -1;
    }

    if (_isMentioning &&
        value.selection.isCollapsed &&
        value.selection.start > _mentionStart) {
      // debugPrint('-- $runtimeType check mention pattern');
      _mentionEnd = value.selection.start;
      final pattern = value.text.substring(
        _mentionStart + 1,
        value.selection.start,
      );
      if (pattern != _mentionPattern) {
        _mentionPattern = pattern;
        _activeConfig = mentionTriggers[_mentionKey]?.cast();
        _debouncer?.cancel();
        _debouncer = Timer(debounce, () {
          _activeConfig
              ?.dataSource(pattern)
              .then((mentionable) => onMentionTrigger(_mentionKey, mentionable))
              .catchError((_) => onMentionTrigger('', []));
        });
      }
    } else {
      /// delay execution to avoid widget rebuild conflicts
      Future.microtask(clearMentionSelection);
    }
  }

  /// update mention range positions
  void _updateMentionPositions(int updates) {
    if (_mentions.isNotEmpty && value.selection.start > -1) {
      // debugPrint('-- $runtimeType check mention range update');
      // update mention range if and only if text value has changed
      if (updates != 0) {
        for (var i = 0; i < _mentions.length; i++) {
          // debugPrint(
          //     '-- $runtimeType selection start: ${value.selection.start}, range start: ${_mentions[i].start}, updates: $updates');
          if (updates > 0) {
            if (_mentions[i].start >= value.selection.start - 1) {
              _mentions[i] = _mentions[i].withRangeMovement(updates);
            }
            // debugPrint('-- $runtimeType update range: ${_mentions[i]}');
          } else {
            if (_mentions[i].start >= value.selection.start - 1) {
              _mentions[i] = _mentions[i].withRangeMovement(updates);
            }
            // debugPrint('-- $runtimeType update range: ${_mentions[i]}');
          }
        }
      }
    }
  }

  /// Builds [TextSpan] from current editing value.
  ///
  /// By default makes text in composing range appear as underlined. Descendants
  /// can override this method to customize appearance of text.
  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    assert(!value.composing.isValid ||
        !withComposing ||
        value.isComposingRangeValid);

    // updates = (-1, 0, 1)
    // delete < selection movement < append
    int updates = value.text.length - _previousLength;
    // update previous length for the next updates result
    _previousLength = value.text.length;

    _identifyMentionStart(updates);
    _removeMention(updates);
    _updateMentionPositions(updates);

    final mentionStyle = style?.merge(TextStyle(
      fontWeight: FontWeight.bold,
      color: mentionColor,
    ));

    // render textspans
    if (_mentions.isNotEmpty) {
      int start = 0;
      return TextSpan(
        style: style,
        children: <TextSpan>[
          // plain text before first mention
          TextSpan(text: text.substring(start, _mentions.first.start)),
          for (var i = 0; i < _mentions.length; i++) ...[
            TextSpan(
              text: text.substring(_mentions[i].start, _mentions[i].end),
              style: mentionStyle,
              mouseCursor: SystemMouseCursors.click,
              recognizer: TapGestureRecognizer()
                ..onTap = () =>
                    mentionTriggers[_mentions[i].trigger]?.onTap(_mentions[i]),
            ),
            // plain text in between mentions
            if (i + 1 < _mentions.length)
              TextSpan(
                text: text.substring(_mentions[i].end, _mentions[i + 1].start),
              ),
          ],
          // plain text after last mention
          TextSpan(text: text.substring(_mentions.last.end, text.length)),
        ],
      );
    } else {
      return TextSpan(style: style, text: text);
    }
  }
}
