import 'package:flutter/material.dart';
import 'package:mention_field/mention_field.dart';

/// {@template mention_configuration}
/// configuration to use when mention trigger has been detected.
/// {@endtemplate}
class MentionConfiguration<T extends Mentionable> {
  /// data source to fetch when trigger has been detected
  final Future<List<T>> Function(String pattern) dataSource;

  /// value to display in text field when mentioned
  // final String Function(T value) mentionableText;

  /// list view item builder for mentionable list
  final Widget Function(
    BuildContext context,
    T value,
    void Function(T value) mention,
  ) listItemBuilder;

  /// onTap handler for mentions
  final void Function(MentionRange mention) onTap;

  /// value to assing in [MentionRange.extra] when adding / selecting new mention
  final Map<String, dynamic> Function(T value) extraValue;

  /// use to support dynamic datasource model
  X cast<X>() => this as X;

  MentionConfiguration({
    required this.listItemBuilder,
    // required this.mentionableText,
    required this.dataSource,
    required this.onTap,
    required this.extraValue,
  });
}
