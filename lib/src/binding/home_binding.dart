import 'package:boozin_fitness/src/controller/home_controller.dart';
import 'package:boozin_fitness/src/screens/home/home.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController(),permanent: false);
    //Get.lazyPut(() => HelthRepository());
  }
}
