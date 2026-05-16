
import '../../../../core/exported_files/exported_file.dart';

class SubscriptionController extends GetxController {
	final RxString selectedSpendFilter = 'Monthly'.obs;

	final List<String> spendFilters = ['Monthly', 'Yearly', 'All'];

	final List<SubscriptionItem> subscriptions = const [
		SubscriptionItem(
			name: 'Spotify',
			amount: 50,
			cycle: 'Month',
			nextBilling: '18 Jun 2026',
			status: SubscriptionStatus.upcoming,
			daysLeft: 14,
		),
		SubscriptionItem(
			name: 'Netflix',
			amount: 1200,
			cycle: 'Year',
			nextBilling: '15 Nov 2026',
			status: SubscriptionStatus.active,
			daysLeft: 185,
		),
		SubscriptionItem(
			name: 'Canva Pro',
			amount: 100,
			cycle: 'Month',
			nextBilling: '05 May 2026',
			status: SubscriptionStatus.expired,
			daysLeft: 0,
		),
	];

	void changeSpendFilter(String filter) {
		selectedSpendFilter.value = filter;
	}

	List<SubscriptionItem> get allSubscriptions => subscriptions;

	List<SubscriptionItem> get upcomingSubscriptions => subscriptions
			.where((item) => item.status == SubscriptionStatus.upcoming)
			.toList(growable: false);

	List<SubscriptionItem> get expiredSubscriptions => subscriptions
			.where((item) => item.status == SubscriptionStatus.expired)
			.toList(growable: false);

	double get monthlySpend => subscriptions
			.where((item) => item.cycle == 'Month')
			.fold(0, (sum, item) => sum + item.amount);

	double get yearlySpend => subscriptions
			.where((item) => item.cycle == 'Year')
			.fold(0, (sum, item) => sum + item.amount);

	int get subscriptionCount => subscriptions.length;

	double get selectedSpend {
		if (selectedSpendFilter.value == 'Monthly') {
			return monthlySpend;
		}

		if (selectedSpendFilter.value == 'Yearly') {
			return yearlySpend;
		}

		return monthlySpend + yearlySpend;
	}

	String get selectedSpendCaption {
		if (selectedSpendFilter.value == 'Monthly') {
			return 'Bills this month';
		}

		if (selectedSpendFilter.value == 'Yearly') {
			return 'Bills this year';
		}

		return 'All subscriptions spend';
	}

	String get topUpcomingTitle {
		if (upcomingSubscriptions.isEmpty) {
			return 'No upcoming bills';
		}

		return upcomingSubscriptions.first.name;
	}

	String get topUpcomingCycle {
		if (upcomingSubscriptions.isEmpty) {
			return '0 active subscriptions';
		}

		return '${upcomingSubscriptions.first.cycle}ly renewal';
	}

	int get activeCount =>
			subscriptions.where((item) => item.status == SubscriptionStatus.active).length;

	int get upcomingCount => upcomingSubscriptions.length;

	int get expiredCount => expiredSubscriptions.length;
}

enum SubscriptionStatus { active, upcoming, expired }

class SubscriptionItem {
	const SubscriptionItem({
		required this.name,
		required this.amount,
		required this.cycle,
		required this.nextBilling,
		required this.status,
		required this.daysLeft,
	});

	final String name;
	final double amount;
	final String cycle;
	final String nextBilling;
	final SubscriptionStatus status;
	final int daysLeft;
}
