import 'dart:convert';

import '../../exported_files/exported_file.dart';
import '../../models/subscription_model.dart';

class SubscriptionStorageService {
  SubscriptionStorageService._();

  static final SubscriptionStorageService instance =
      SubscriptionStorageService._();

  static const String _storageKey = 'subscription_records';

  final STService _storage = STService();

  Future<void> _writeSubscriptions(
    List<SubscriptionModel> subscriptions,
  ) async {
    final List<Map<String, dynamic>> payload = subscriptions
        .map((item) => item.toJson())
        .toList(growable: false);

    await _storage.saveData(_storageKey, jsonEncode(payload));
  }

  Future<List<SubscriptionModel>> readSubscriptions() async {
    final String? rawData = _storage.getData(_storageKey);
    if (rawData == null || rawData.isEmpty) {
      return [];
    }

    final List<dynamic> decoded = jsonDecode(rawData) as List<dynamic>;
    return decoded
        .map((item) => SubscriptionModel.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);
  }

  Future<void> saveSubscription(SubscriptionModel subscription) async {
    final List<SubscriptionModel> currentSubscriptions =
        await readSubscriptions();
    await _writeSubscriptions([...currentSubscriptions, subscription]);
  }

  Future<void> updateSubscription(SubscriptionModel subscription) async {
    final List<SubscriptionModel> currentSubscriptions =
        await readSubscriptions();
    final List<SubscriptionModel> updatedSubscriptions = currentSubscriptions
        .map((item) => item.id == subscription.id ? subscription : item)
        .toList(growable: false);

    await _writeSubscriptions(updatedSubscriptions);
  }

  Future<void> deleteSubscription(String id) async {
    final List<SubscriptionModel> currentSubscriptions =
        await readSubscriptions();
    final List<SubscriptionModel> updatedSubscriptions = currentSubscriptions
        .where((item) => item.id != id)
        .toList(growable: false);

    await _writeSubscriptions(updatedSubscriptions);
  }
}
