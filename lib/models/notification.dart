class Notification {
  final int? id;
  final int contractId;
  final String type;
  final String title;
  final String message;
  final int? daysBefore;
  final bool isRead;
  final DateTime timestampINS;

  Notification({
    this.id,
    required this.contractId,
    required this.type,
    required this.title,
    required this.message,
    this.daysBefore,
    required this.isRead,
    required this.timestampINS,
  });
}