import 'package:get/get.dart';
import 'package:health/health.dart';

enum AppState {
  DATA_NOT_FETCHED, FETCHING_DATA, DATA_READY, NO_DATA, AUTH_NOT_GRANTED, DATA_ADDED, DATA_NOT_ADDED, STEPS_READY,
}

class HelthService {
  static HealthFactory health = HealthFactory();

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

    List<HealthDataPoint> _healthDataList = [];

    /// Give a HealthDataType with the given identifier
    final types = [
      HealthDataType.STEPS,
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.BLOOD_GLUCOSE,
    ];

    /// Give a permissions for the given HealthDataTypes
    final permissions = [
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
    ];

    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    List<HealthDataPoint> healthData = [];



    /// request google Authorization when the app is opened for the first time
    bool requested = await health.requestAuthorization(types, permissions: permissions);

    // write steps and blood glucose
    bool success =
    //await health.writeHealthData(10, HealthDataType.STEPS, now, now);
    //success =
    await health.writeHealthData(3.1, HealthDataType.BLOOD_GLUCOSE, now, now);
 print("success data: $success");
    // get the number of steps for today
    // var midnight = DateTime(now.year, now.month, now.day);
    // int? steps = await health.getTotalStepsInInterval(midnight, now);

    RxInt steps = 0.obs;
    RxInt  blood = 0.obs;
    if (requested) {
      try {
        steps.value = (await health.getTotalStepsInInterval(yesterday, now))!;

      } catch (error) {
        print("Caught exception in getTotalStepsInInterval: $error");
      }
      //print('Total number of steps -:- ${steps.value}');

      healthData = await health.getHealthDataFromTypes(yesterday, now, types);

      // _healthDataList.addAll((healthData.length <200)
      //     ? healthData
      //     : healthData.sublist(0,100));
      // print("hlist: ${_healthDataList}");
    } else {
      throw AuthenticationRequired();
    }
    return healthData;
  }

}

class AuthenticationRequired extends Error {}
