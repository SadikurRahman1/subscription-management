import 'package:get/get.dart';


import 'en_us.dart';
import 'bn_us.dart';
class AppTranslation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {'en_US': enUS, 'bn_US': bnUS};
}