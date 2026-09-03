class Contract {
  final String client;
  final String type;
  final String number;
  final String startDate;
  final String expirationDate;
  final double? amount;
  final String frequency;
  final String filePath;
  final String notes;

  Contract({
    required this.client,
    required this.type,
    required this.number,
    required this.startDate,
    required this.expirationDate,
    this.amount,
    required this.frequency,
    required this.filePath,
    required this.notes,
  });
}