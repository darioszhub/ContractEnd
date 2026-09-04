class Client {
  final int? id;
  final String name;
  final String surname;
  final String? company;
  final String? taxCode;
  final String? vat;
  final String? phone;
  final String? email;
  final String? address;
  final String? city;
  final String? notes;
  final DateTime timestampINS;
  final DateTime? timestampEDT;

  Client({
    this.id,
    required this.name,
    required this.surname,
    this.company,
    this.taxCode,
    this.vat,
    this.phone,
    this.email,
    this.address,
    this.city,
    this.notes,
    required this.timestampINS,
    this.timestampEDT,
  });
}