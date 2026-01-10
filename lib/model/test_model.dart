class VehicleBasicModel {
  final int userId;
  final int vehicleId;
  final String trim;
  final int color;
  final String rideTypes;
  final String greenCarId;



  VehicleBasicModel({
    required this.userId,
    required this.vehicleId,
    required this.trim,
    required this.color,
    required this.rideTypes,
    required this.greenCarId,


  });

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "vehicle_id": vehicleId,
      "trim": trim,
      "color": color,
      "ride_types": rideTypes,
      "green_car_id": greenCarId,

    };
  }
}
