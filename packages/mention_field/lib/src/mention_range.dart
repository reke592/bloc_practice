/// {@template mention_range}
/// domain model for mentions
///
/// mentions are identifiable via position in string, it contains extra metadata for other ui widgets to consume.
/// {@endtemplate}
class MentionRange {
  /// this trigger can be used to identify the functionality of this mention
  final String trigger;

  /// substring position start
  final int start;

  /// substring position end
  final int end;

  /// metadata to consume by other ui widgets
  final Map<String, dynamic> extra;

  /// {@macro mention_range}
  const MentionRange({
    required this.trigger,
    required this.start,
    required this.end,
    required this.extra,
  });

  MentionRange copyWith({
    int? start,
    int? end,
    String? text,
    Map<String, dynamic>? extra,
  }) =>
      MentionRange(
        trigger: trigger,
        start: start ?? this.start,
        end: end ?? this.end,
        extra: extra ?? this.extra,
      );

  MentionRange withRangeMovement(int updates) => copyWith(
        start: start + updates,
        end: end + updates,
        extra: extra,
      );

  factory MentionRange.fromJson(Map<String, dynamic> json) => MentionRange(
        trigger: json['trigger'],
        start: json['start'],
        end: json['end'],
        extra: Map<String, dynamic>.from(json['extra']),
      );

  Map<String, dynamic> toJson() => {
        'trigger': trigger,
        'start': start,
        'end': end,
        'extra': extra,
      };

  @override
  String toString() => '$runtimeType ($trigger, $start, $end, $extra)';
}
