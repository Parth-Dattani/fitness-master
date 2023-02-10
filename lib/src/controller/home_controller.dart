import 'package:boozin_fitness/src/services/health_services.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';

class HomeController extends GetxController {
  var healthPoint = <HealthDataPoint>[].obs;
  var error = "".obs;
  var isLoading = false.obs;
  RxInt nofSteps = 10.obs;

  HealthFactory health = HealthFactory();
  AppState state = AppState.DATA_NOT_FETCHED;

  @override
  void onInit() {
    super.onInit();
    fetchHealthData();
  }

  void fetchHealthData() async {
    try {
      isLoading.value = true;
      final healthData = await HelthService.fetchHealthData();
      healthPoint.assignAll(healthData);
      error.value = "";
      isLoading.value = false;
    } catch (e) {
      error.value = e.toString();
    }
    update();
  }

  /// Fetch steps from the health plugin and show them in the app.
  Future fetchStepData() async {
    RxInt steps = 0.obs;

    // get steps for today (i.e., since midnight)
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    bool requested = await health.requestAuthorization([HealthDataType.STEPS]);

    if (requested) {
      try {
        steps.value = (await health.getTotalStepsInInterval(midnight, now))!;
      } catch (error) {
        print("Caught exception in getTotalStepsInInterval: $error");
      }

      print('Total number of steps: $steps');

      //setState(() {
        nofSteps = ((steps.value == 0) ? 0 : steps.value) as RxInt;
        state = (steps.value == 0) ? AppState.NO_DATA : AppState.STEPS_READY;
      //});
    }
    else {
      print("Authorization not granted - error in authorization");
      //setState(() =>
      state = AppState.DATA_NOT_FETCHED;
      //);
    }
  }

}
