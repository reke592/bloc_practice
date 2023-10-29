class TicketStatus {
  final String name;
  TicketStatus({required this.name});

  factory TicketStatus.fromJson(Map<String, dynamic> json) => TicketStatus(
        name: json['name'],
      );
}
