/// DTO model for mentions
class MentionRange {
  final String trigger;
  final int start;
  final int end;
  final String text;
  final Map<String, dynamic> extra;

  const MentionRange({
    required this.trigger,
    required this.start,
    required this.end,
    required this.text,
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
        text: text ?? this.text,
        extra: extra ?? this.extra,
      );

  MentionRange withRangeMovement(int updates) => copyWith(
        start: start + updates,
        end: end + updates,
        text: text,
        extra: extra,
      );

  factory MentionRange.fromJson(Map<String, dynamic> json) => MentionRange(
        trigger: json['trigger'],
        start: json['start'],
        end: json['end'],
        text: json['text'],
        extra: Map<String, dynamic>.from(json['extra']),
      );

  Map<String, dynamic> toJson() => {
        'trigger': trigger,
        'start': start,
        'end': end,
        'text': text,
      };

  @override
  String toString() => '$runtimeType ($trigger, $start, $end, $text, $extra)';
}
