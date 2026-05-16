import '../../../../core/exported_files/exported_file.dart';
import 'package:subscription_manage/feature/subscription/presentation/controller/subscription_controller.dart';
import '../controller/main_bottom_nav_controller.dart';

class MainBottomNavBinding implements Bindings {
	@override
	void dependencies() {
		
		Get.lazyPut(() => SubscriptionController());
    Get.lazyPut(() => MainBottomNavController());
	}
}
