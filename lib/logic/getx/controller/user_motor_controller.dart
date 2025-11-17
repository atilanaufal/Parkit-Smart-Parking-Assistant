import 'package:get/get.dart';

class UserMotorController extends GetxController {
  // List motor user (maks 5)
  RxList<Map<String, String>> motors = <Map<String, String>>[].obs;

  bool get isFull => motors.length >= 5;

  void addMotor(String name, String dimension, String color, String type) {
    if (isFull) return;
    motors.add({
      "name": name,
      "dimension": dimension,
      "color": color,
      "type": type,
    });
  }

  void updateMotor(
    int index,
    String name,
    String dimension,
    String color,
    String type,
  ) {
    motors[index] = {
      "name": name,
      "dimension": dimension,
      "color": color,
      "type": type,
    };
    motors.refresh();
  }

  void removeMotor(int index) {
    motors.removeAt(index);
    motors.refresh(); // penting untuk update UI
  }
}
