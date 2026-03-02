class CarItem {
  final int id;
  final int? userId;
  final String? address;
  final double? lat;
  final double? long;
  final DateTime activeForm;
  final DateTime activeTill; // ✅ correct Dart field
  final int? vehicleId;
  final String? greenCarType;
  final int? modelYear;
  final String? trim;
  final int? color;
  final int? numSeats;
  final int? numSeats4riders;
  final bool? isApproved;
  final String? rideTypes;
  final bool? isLux;
  final bool? isDefault;
  final bool? isInUse;
  final bool? isOffline;
  final String? amenities;
  final String? insExpDate;
  final String? insPolicyNum;
  final String? dtAdded;
  final String? dtModified;
  final String? dtOffline;
  final String? licensePlateNum;
  final String? rideTypesVeh;
  final String? prefsSel;
  final String? prefsDel;
  final String? preferencesOther;
  final String? picVehicleIns;
  final String? picVehicleReg;
  final String? picVehicleInspection;
  final String? picVehicleImage;
  final bool? isActive;
  final bool? isBooked;

  /// NEW FIELDS
  final double? hourlyCost;
  final double? dailyCost;
  final double? weeklyCost;
  final int? availabilityInHours;
  final int? availabilityInDays;
  final int? availabilityInWeeks;
  final VehicleInfo? vehicle;
  final bool? isNewlyAdded;

  CarItem({
    required this.id,
    this.userId,
    this.address,
    this.lat,
    this.long,
    required this.activeForm,
    required this.activeTill,
    this.vehicleId,
    this.greenCarType,
    this.modelYear,
    this.trim,
    this.color,
    this.numSeats,
    this.numSeats4riders,
    this.isApproved,
    this.rideTypes,
    this.isLux,
    this.isDefault,
    this.isInUse,
    this.isOffline,
    this.amenities,
    this.insExpDate,
    this.insPolicyNum,
    this.dtAdded,
    this.dtModified,
    this.dtOffline,
    this.licensePlateNum,
    this.rideTypesVeh,
    this.prefsSel,
    this.prefsDel,
    this.preferencesOther,
    this.picVehicleIns,
    this.picVehicleReg,
    this.picVehicleInspection,
    this.picVehicleImage,
    this.isActive,
    this.isBooked,
    this.hourlyCost,
    this.dailyCost,
    this.weeklyCost,
    this.vehicle,
    this.isNewlyAdded,
    this.availabilityInDays,
    this.availabilityInHours,
    this.availabilityInWeeks
  });

  factory CarItem.fromJson(Map<String, dynamic> json) {
    return CarItem(
      id: json["id"],
      userId: json["user_id"],
      vehicleId: json["vehicle_id"],
      address: json["address"],
      lat: (json['lat'] as num?)?.toDouble(),
      long: (json['long'] as num?)?.toDouble(),
      activeForm: json['active_from'] != null
          ? DateTime.tryParse(json['active_from']) ?? DateTime.now()
          : DateTime.now(),

      activeTill: json['active_till'] != null
          ? DateTime.tryParse(json['active_till']) ?? DateTime.now()
          : DateTime.now(),
      greenCarType: json["green_car_type"],
      modelYear: json["model_year"],
      trim: json["trim"],
      color: json["color"],
      numSeats: json["num_seats"],
      numSeats4riders: json["num_seats4riders"],
      isApproved: json["is_approved"],
      rideTypes: json["ride_types"],
      isLux: json["is_lux"],
      isDefault: json["is_default"],
      isInUse: json["is_in_use"],
      isOffline: json["is_offline"],
      amenities: json["amenities"],
      insExpDate: json["ins_exp_date"],
      insPolicyNum: json["ins_policy_num"],
      dtAdded: json["dt_added"],
      dtModified: json["dt_modified"],
      dtOffline: json["dt_offline"],
      licensePlateNum: json["license_plate_num"],
      rideTypesVeh: json["ride_types_veh"],
      prefsSel: json["prefs_sel"],
      prefsDel: json["prefs_del"],
      preferencesOther: json["preferences_other"],
      picVehicleIns: json["pic_vehicle_ins"],
      picVehicleReg: json["pic_vehicle_reg"],
      picVehicleInspection: json["pic_vehicle_inspection"],
      picVehicleImage: json["pic_vehicle_image"],
      isActive: json["is_active"],
      isBooked: json["is_booked"],

      /// AVAILABILITY ✅
      availabilityInHours: json["availability_in_hours"],
      availabilityInDays: json["availability_in_days"],
      availabilityInWeeks: json["availability_in_weeks"],

      /// NEW – correct mapping
      hourlyCost: json["hourly_cost"] == null
          ? null
          : (json["hourly_cost"] as num).toDouble(),

      dailyCost: json["daily_cost"] == null
          ? null
          : (json["daily_cost"] as num).toDouble(),

      weeklyCost: json["weekly_cost"] == null
          ? null
          : (json["weekly_cost"] as num).toDouble(),



      vehicle: json["vehicle"] != null
          ? VehicleInfo.fromJson(json["vehicle"])
          : null,

      isNewlyAdded: json["is_newly_added"],
    );
  }
}

class VehicleInfo {
  final int modelId;
  final int makeId;
  final int year;
  final String make;
  final String model;
  final String name;
  final int seatingCapacity;
  final bool isLux;
  final bool isSuv;

  VehicleInfo({
    required this.modelId,
    required this.makeId,
    required this.year,
    required this.make,
    required this.model,
    required this.name,
    required this.seatingCapacity,
    required this.isLux,
    required this.isSuv,
  });

  factory VehicleInfo.fromJson(Map<String, dynamic> json) {
    return VehicleInfo(
      modelId: json["model_id"],
      makeId: json["make_id"],
      year: json["year"],
      make: json["make"],
      model: json["model"],
      name: json["name"],
      seatingCapacity: json["seating_capacity"],
      isLux: json["is_lux"],
      isSuv: json["is_suv"],
    );
  }
}


// users apis models

class UserDetails {
  final int id;
  final int userId;
  final bool isApproved;
  final String? picInsurance;
  final String? picDriverLic;
  final String insPolicyNum;
  final String driverLicNum;

  UserDetails({
    required this.id,
    required this.userId,
    required this.isApproved,
    this.picInsurance,
    this.picDriverLic,
    required this.insPolicyNum,
    required this.driverLicNum,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json["id"],
      userId: json["user_id"],
      isApproved: json["is_approved"] ?? false,
      picInsurance: json["pic_insurance"],
      picDriverLic: json["pic_driver_lic"],
      insPolicyNum: json["ins_policy_num"] ?? "",
      driverLicNum: json["driver_lic_num"] ?? "",
    );
  }
}

class UserDetailsResponse {
  final bool success;
  final String message;
  final List<UserDetails> data;

  UserDetailsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UserDetailsResponse.fromJson(Map<String, dynamic> json) {
    return UserDetailsResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null
          ? []
          : List<UserDetails>.from(
          json["data"].map((x) => UserDetails.fromJson(x))),
    );
  }
}

class UserResponse {
  final bool success;
  final String message;
  final UserData data;

  UserResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      success: json["success"],
      message: json["message"],
      data: UserData.fromJson(json["data"]),
    );
  }
}

class UserData {
  final int id;
  final int userId;
  final bool isApproved;
  final String? picInsurance;
  final String? picDriverLic;
  final String? insPolicyNum;
  final String? driverLicNum;

  UserData({
    required this.id,
    required this.userId,
    required this.isApproved,
    this.picInsurance,
    this.picDriverLic,
    this.insPolicyNum,
    this.driverLicNum,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json["id"],
      userId: json["user_id"],
      isApproved: json["is_approved"],
      picInsurance: json["pic_insurance"],
      picDriverLic: json["pic_driver_lic"],
      insPolicyNum: json["ins_policy_num"],
      driverLicNum: json["driver_lic_num"],
    );
  }
}
