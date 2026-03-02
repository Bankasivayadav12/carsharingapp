class TimeSharingVehicle {
  final int id;
  final int userId;
  final int vehicleId;
  final String? trim;
  final String rideTypes;
  final bool isDefault;
  final bool isActive;
  final bool isBooked;
  final double lat;
  final double long;
  final double hourlyCost;
  final double dailyCost;
  final double weeklyCost;
  final String address;
  final VehicleDetails vehicle;

  TimeSharingVehicle({
    required this.id,
    required this.userId,
    required this.vehicleId,
    required this.trim,
    required this.rideTypes,
    required this.isDefault,
    required this.isActive,
    required this.isBooked,
    required this.lat,
    required this.long,
    required this.hourlyCost,
    required this.dailyCost,
    required this.weeklyCost,
    required this.address,
    required this.vehicle,
  });

  factory TimeSharingVehicle.fromJson(Map<String, dynamic> json) {
    return TimeSharingVehicle(
      id: json['id'],
      userId: json['user_id'],
      vehicleId: json['vehicle_id'],
      trim: json['trim'],
      rideTypes: json['ride_types'],
      isDefault: json['is_default'] ?? false,
      isActive: json['is_active'] ?? false,
      isBooked: json['is_booked'] ?? false,
      lat: double.parse(json['lat'].toString()),
      long: double.parse(json['long'].toString()),
      hourlyCost: (json['hourly_cost'] ?? 0).toDouble(),
      dailyCost: (json['daily_cost'] ?? 0).toDouble(),
      weeklyCost: (json['weekly_cost'] ?? 0).toDouble(),
      address: json['address'] ?? "",
      vehicle: VehicleDetails.fromJson(json['vehicle']),
    );
  }

  get vehicleImageUrl => null;
}

class VehicleDetails {
  final String make;
  final String model;
  final int year;
  final int seatingCapacity;
  final bool isSuv;

  VehicleDetails({
    required this.make,
    required this.model,
    required this.year,
    required this.seatingCapacity,
    required this.isSuv,
  });

  factory VehicleDetails.fromJson(Map<String, dynamic> json) {
    return VehicleDetails(
      make: json['make'],
      model: json['model'],
      year: json['year'],
      seatingCapacity: json['seating_capacity'],
      isSuv: json['is_suv'] ?? false,
    );
  }
}


