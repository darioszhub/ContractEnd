class Contract {
  final int? id;
  final int clientId;
  final String type;
  final String number;
  final String startDate;
  final String expirationDate;
  final double? amount;
  final String frequency;
  final String? agent;
  final String? codagent;
  final String? clientType;
  final String? mercCategory;
  final String? invoicePeriod;
  final double? meterPower;
  final double? annualVolume;
  final String? offerType;
  final double? variableSpreadNew;
  final double? variableSpreadOld;
  final String? currentManager;
  final String? acquisitionDate;
  final String? previousManager;
  final String? expirationNoticeDate;
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
    this.agent,
    this.codagent,
    this.clientType,
    this.mercCategory,
    this.invoicePeriod,
    this.meterPower,
    this.annualVolume,
    this.offerType,
    this.variableSpreadNew,
    this.variableSpreadOld,
    this.currentManager,
    this.acquisitionDate,
    this.previousManager,
    this.expirationNoticeDate,
    this.filePath,
    this.notes,
    required this.timestampINS,
    this.timestampEDT,
  });
}
