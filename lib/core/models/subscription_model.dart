class SubscriptionModel {
  SubscriptionModel({
    required this.id,
    required this.subscriptionName,
    required this.cost,
    required this.paymentCycle,
    required this.startDate,
    required this.paymentMethod,
    required this.createdAt,
    this.note,
  });

  final String id;
  final String subscriptionName;
  final double cost;
  final String paymentCycle;
  final DateTime startDate;
  final String paymentMethod;
  final String? note;
  final DateTime createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subscriptionName': subscriptionName,
      'cost': cost,
      'paymentCycle': paymentCycle,
      'startDate': startDate.toIso8601String(),
      'paymentMethod': paymentMethod,
      'note': note,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'] as String,
      subscriptionName: json['subscriptionName'] as String,
      cost: (json['cost'] as num).toDouble(),
      paymentCycle: json['paymentCycle'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      paymentMethod: json['paymentMethod'] as String,
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}