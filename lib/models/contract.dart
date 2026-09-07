class Contract {
  final int? id;
  final int clientId;
  final String type;
  final String number;
  final String startDate;
  final String expirationDate;
  final double? amount;
  final String frequency;
  final String? filePath;
  final String? notes;
  final DateTime timestampINS;
  final DateTime? timestampEDT;

  Contract({
    this.id,
    required this.clientId,
    required this.type,
    required this.number,
    required this.startDate,
    required this.expirationDate,
    this.amount,
    required this.frequency,
    this.filePath,
    this.notes,
    required this.timestampINS,
    this.timestampEDT,
  });
}