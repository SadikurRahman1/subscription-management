import 'package:get/get.dart';

class MainBottomNavController extends GetxController {
	final RxInt selectedIndex = 0.obs;

	@override
	void onInit() {
		super.onInit();
		final dynamic initialTab = Get.arguments;
		if (initialTab is int) {
			selectedIndex.value = initialTab;
		}
	}

	void changeTab(int index) {
		selectedIndex.value = index;
	}
}
