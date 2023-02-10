import 'package:get/get.dart';
import 'package:health/health.dart';

enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTH_NOT_GRANTED,
  DATA_ADDED,
  DATA_NOT_ADDED,
  STEPS_READY,
}

class HelthService {
  static HealthFactory health = HealthFactory();
  /// Fetch steps from the health plugin and show them in the app.
  /*Future fetchStepData() async {
    RxInt steps = 0.obs;
    RxInt nofSteps = 10.obs;
    AppState state = AppState.DATA_NOT_FETCHED;

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

//      setState(() {
        nofSteps.value = (steps.value == null) ? 0 : steps.value;
        state = (steps.value == null) ? AppState.NO_DATA : AppState.STEPS_READY;
  //    });
    } else {
      print("Authorization not granted - error in authorization");
      //setState(() =>
      state = AppState.DATA_NOT_FETCHED;
    //);
    }
  }*/


  static Future<List<HealthDataPoint>> fetchHealthData() async {
    final types = [
      HealthDataType.STEPS,
      HealthDataType.ACTIVE_ENERGY_BURNED,
    ];
    AppState state = AppState.DATA_NOT_FETCHED;
    int nofSteps = 10;

    final permissions = [
      HealthDataAccess.READ,
      HealthDataAccess.READ,
    ];

    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    List<HealthDataPoint> healthData = [];

    bool requested = await health.requestAuthorization(types, permissions: permissions);


    if (requested) {
      // try {
      //   steps = await health.getTotalStepsInInterval(yesterday, now);
      // } catch (error) {
      //   print("Caught exception in getTotalStepsInInterval: $error");
      // }
      // print('Total number of steps: $steps');
      // nofSteps = (steps == null) ? 0 : steps;
      // state = (steps == null) ? AppState.NO_DATA : AppState.STEPS_READY;

      healthData = await health.getHealthDataFromTypes(yesterday, now, types);
    } else {
      throw AuthenticationRequired();
      // print("Authorization not granted - error in authorization");
      //  state = AppState.DATA_NOT_FETCHED;
    }
    return healthData;
  }


}

class AuthenticationRequired extends Error {}
