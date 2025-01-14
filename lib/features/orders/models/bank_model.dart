final class BankModel {
  const BankModel({
    required this.name,
    required this.account,
    required this.commission,
  });

  final String name;
  final String account;
  final int commission;

  factory BankModel.fromMap(Map<String, dynamic> map) => BankModel(
        name: map['name'],
        account: map['account'],
        commission: map['commission'],
      );
}
