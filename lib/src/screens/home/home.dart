
import 'package:boozin_fitness/src/controller/home_controller.dart';
import 'package:boozin_fitness/src/utils/font_style.dart';
import 'package:boozin_fitness/src/utils/image_path.dart';
import 'package:boozin_fitness/src/utils/loading_shimmer.dart';
import 'package:boozin_fitness/src/utils/strings.dart';
import 'package:boozin_fitness/src/widgets/home_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:boozin_fitness/src/widgets/error.dart' as error;

class Home extends GetView<HomeController> {
  const Home({Key? key}) : super(key: key);

  /// route: '/home'
  static const String route = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 50, 16, 10),
        child: Obx(() {
          final _healthPoint = controller.healthPoint;
          num steps;
          num calories;
          if (controller.error.isNotEmpty) {
            return error.Error(controller: controller);
          }

          /// get data from repository and assing to steps and calories
          if (_healthPoint.isNotEmpty) {
            steps = _healthPoint.first.value;
            calories = _healthPoint.last.value;
          } else {
            steps = 0;
            calories = 0;
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
               "Fitness",
                style: TextStyle(
                  fontSize: 32,
                  fontFamily: AppFont.nunito,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 40),

              /// if steps is null show shimmer
              LoadingShimmer(
                loading: controller.isLoading.value,
                //if steps is not null show steps
                child: HomeCard(
                  iconPath: ImagePath(context).iconFootSteps,
                  heading: AppText.steps,
                  value: steps.toDouble(),
                  title: '$steps',
                  goal: '15,000',
                ),
              ),

              /// if calories is null show shimmer
              LoadingShimmer(
                loading: controller.isLoading.value,
                //if calories is not null show calories
                child: HomeCard(
                  iconPath: ImagePath(context).iconKcal,
                  heading: AppText.caloriesBurned,
                  value: calories.toDouble(),
                  title: '$calories',
                  goal: '15,000',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 15.0,
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: MediaQuery.of(context).size.width * 0.55,
                  child: Card(
                    color: const Color(0xffff6968),
                    shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '  Steps Count',
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        bottomLeft: Radius.circular(30),
                                        bottomRight: Radius.circular(30)),
                                    color: Color.fromRGBO(255, 255, 255, 0.38)),
                                child: IconButton(
                                  onPressed: () {
                                   // fetchStepData();
                                    controller.fetchHealthData();
                                    //controller.fetchStepData();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Refresh Data"),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.refresh,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Container(
                              alignment: Alignment.topLeft,
                              padding: const EdgeInsets.only(left: 10, bottom: 20),
                              child: Text(
                                //'${controller.nofSteps.obs} steps ',
                                '${steps} steps ',
                                style:
                                const TextStyle(fontSize: 27, color: Colors.white),
                              )),
                          Container(
                              alignment: Alignment.bottomRight,
                              padding: EdgeInsets.only(right: 10),
                              child: Column(
                                children: const [
                                  Text(
                                    'Healthy',
                                    style: TextStyle(fontSize: 18, color: Colors.white),
                                  ),
                                  Text(
                                    '50-120',
                                    style: TextStyle(fontSize: 18, color: Colors.white),
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // ElevatedButton(
              //     child: const Text("Go To HomeScreen"),
              //     onPressed: () {
              //       Navigator.push(context,
              //           MaterialPageRoute(builder: (context) => StepCount()));
              //     }),
            ],
          );
        }),
      ),
    );
  }
}
