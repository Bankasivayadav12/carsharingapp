import 'package:get/get.dart';

class BookingController extends GetxController {

  RxInt bookingId = 0.obs;
  RxString orderId = "".obs;
  RxDouble amount = 0.0.obs;
  RxString carName = "".obs;
  RxString pickupAddress = "".obs;
  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);

  void setBookingData({
    required int bookingId,
    required String orderId,
    required double amount,
    required String carName,
    required String pickupAddress,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    this.bookingId.value = bookingId;
    this.orderId.value = orderId;
    this.amount.value = amount;
    this.carName.value = carName;
    this.pickupAddress.value = pickupAddress;
    this.startDate.value = startDate;
    this.endDate.value = endDate;
  }
}
