import 'package:get/get.dart';

class ParkingLocationController extends GetxController {
  RxBool isParked = false.obs;

  RxString parkir = "-".obs;
  RxString baris = "-".obs;
  RxString slot = "-".obs;

  // reset
  void clearParking() {
    isParked.value = false;
    parkir.value = "-";
    baris.value = "-";
    slot.value = "-";
  }

  // set parking selection
  void setParking(String parkirVal, String barisVal, String slotVal) {
    parkir.value = parkirVal;
    baris.value = barisVal;
    slot.value = slotVal;
    isParked.value = true;
  }
}
