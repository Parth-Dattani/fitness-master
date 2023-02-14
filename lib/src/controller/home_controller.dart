import 'package:boozin_fitness/src/services/health_services.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeController extends GetxController {
  var healthPoint = <HealthDataPoint>[].obs;
  var error = "".obs;
  var isLoading = false.obs;
  RxInt nofSteps = 0.obs;
  RxInt steps = 0.obs;
  RxInt calories = 0.obs;
  HealthFactory health = HealthFactory();
  AppState state = AppState.DATA_NOT_FETCHED;
  double mgdl = 10.0;

  @override
  void onInit() {
    super.onInit();
    checkPermissions();
    fetchHealthData();
    fetchStepData();
  }

  void checkPermissions() async {

    Map<Permission, PermissionStatus> statuses = await [
      Permission.activityRecognition,
      Permission.notification,
      Permission.location,
    ].request();
    // perform custom action

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
        nofSteps.value = (steps == null) ? 0 : steps.value;
        state = (steps.value == null) ? AppState.NO_DATA : AppState.STEPS_READY;
      //});
    } else {
      print("Authorization not granted - error in authorization");
      //setState(() =>
      state = AppState.DATA_NOT_FETCHED;
      //);
    }
  }

  // void hb() async{
  //   final heartRateData = await GoogleFit.readHeartRate(
  //     DataTypeName.HEART_RATE_BPM,
  //     DateTime.now().subtract(Duration(days: 7)),
  //     DateTime.now(),
  //   );
  //
  // }


  // void read() async {
  //   final results = await health.getHealthDataFromTypes(
  //       DateTime.now(),
  //       DateTime.now().subtract(Duration(days: 5)),
  //       [ HealthDataType.HEART_RATE,]
  //   );
  //   print("object :-- ${results}");
  // }

  // void readLast() async {
  //   final result = await FitKit.readLast(DataType.HEIGHT);
  // }

  // void readAll() async {
  //   if (await FitKit.requestPermissions(DataType.values)) {
  //     for (DataType type in DataType.values) {
  //       final results = await FitKit.read(
  //         type,
  //         dateFrom: DateTime.now().subtract(Duration(days: 5)),
  //         dateTo: DateTime.now(),
  //       );
  //     }
  //   }
  // }
}
