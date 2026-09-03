import '../models/contract.dart';

class ContractRepository {
  static final ContractRepository instance = ContractRepository._internal();

  ContractRepository._internal();

  final List<Contract> _contracts = [
    Contract(
      client: 'Mario Rossi',
      type: 'Telefonia',
      number: 'CTR-2025-001',
      startDate: '15/10/2025',
      expirationDate: '15/10/2026',
      amount: 49.90,
      frequency: 'Mensile',
      filePath: '',
      notes: '',
    ),
    Contract(
      client: 'Luca Bianchi',
      type: 'Internet',
      number: 'CTR-2025-002',
      startDate: '05/09/2025',
      expirationDate: '05/09/2026',
      amount: 39.90,
      frequency: 'Mensile',
      filePath: '',
      notes: '',
    ),
    Contract(
      client: 'Alfa S.r.l.',
      type: 'Energia',
      number: 'CTR-2026-015',
      startDate: '20/09/2025',
      expirationDate: '20/09/2026',
      amount: 1250.00,
      frequency: 'Annuale',
      filePath: '',
      notes: '',
    ),
  ];

  List<Contract> get contracts => _contracts;

  void add(Contract contract) {
    _contracts.add(contract);
  }

  void update(int index, Contract contract) {
    _contracts[index] = contract;
  }

  void delete(Contract contract) {
    _contracts.remove(contract);
  }
}
