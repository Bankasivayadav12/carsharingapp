
// get api to show cars ex: user 198  added cars list to share
import 'dart:convert';

import 'package:flutter/cupertino.dart';

class VehicleResponse {
  final int id;
  final int userId;
  final int vehicleId;

  final String? greenCarType;
  final int? modelYear;
  final String? trim;
  final int? color;
  final int? numSeats;
  final int? numSeats4Riders;

  final bool? isApproved;
  final String? rideTypes;
  final bool? isLux;
  final bool? isDefault;
  final bool? isInUse;
  final bool? isOffline;
  final bool? isActive;
  final bool? isBooked;
  final bool? isNewlyAdded;

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

  /// 💰 COST
  final double? hourlyCost;
  final double? dailyCost;
  final double? weeklyCost;

  /// 📍 LOCATION (IMPORTANT)
  final double? lat;
  final double? long;

  final String? address;

  final VehicleDetails? vehicle;

  VehicleResponse({
    required this.id,
    required this.userId,
    required this.vehicleId,
    this.greenCarType,
    this.modelYear,
    this.trim,
    this.color,
    this.numSeats,
    this.numSeats4Riders,
    this.isApproved,
    this.rideTypes,
    this.isLux,
    this.isDefault,
    this.isInUse,
    this.isOffline,
    this.isActive,
    this.isBooked,
    this.isNewlyAdded,
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
    this.hourlyCost,
    this.dailyCost,
    this.weeklyCost,
    this.lat,
    this.long,
    this.address,
    this.vehicle,
  });

  factory VehicleResponse.fromJson(Map<String, dynamic> json) {
    return VehicleResponse(
      id: json["id"],
      userId: json["user_id"],
      vehicleId: json["vehicle_id"],

      greenCarType: json["green_car_type"],
      modelYear: json["model_year"],
      trim: json["trim"],
      color: json["color"],
      numSeats: json["num_seats"],
      numSeats4Riders: json["num_seats4riders"],

      isApproved: json["is_approved"],
      rideTypes: json["ride_types"],
      isLux: json["is_lux"],
      isDefault: json["is_default"],
      isInUse: json["is_in_use"],
      isOffline: json["is_offline"],
      isActive: json["is_active"],
      isBooked: json["is_booked"],
      isNewlyAdded: json["is_newly_added"],

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

      /// 💰 COST (safe conversion)
      hourlyCost: (json["hourly_cost"] as num?)?.toDouble(),
      dailyCost: (json["daily_cost"] as num?)?.toDouble(),
      weeklyCost: (json["weekly_cost"] as num?)?.toDouble(),

      /// 📍 LOCATION (THIS FIXES YOUR EDIT ISSUE)
      lat: (json["lat"] as num?)?.toDouble(),
      long: (json["long"] as num?)?.toDouble(),

      address: json["address"],

      vehicle: json["vehicle"] != null
          ? VehicleDetails.fromJson(json["vehicle"])
          : null,
    );
  }
}




class VehicleDetails {
  final int? modelId;
  final int? makeId;
  final int? year;
  final String? make;
  final String? model;
  final String? name;
  final int? seatingCapacity;
  final bool? isLux;
  final bool? isSuv;

  VehicleDetails({
    this.modelId,
    this.makeId,
    this.year,
    this.make,
    this.model,
    this.name,
    this.seatingCapacity,
    this.isLux,
    this.isSuv,
  });

  factory VehicleDetails.fromJson(Map<String, dynamic> json) {
    return VehicleDetails(
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
class ColorModel {
  final int id;
  final String name;

  ColorModel({
    required this.id,
    required this.name,
  });

  factory ColorModel.fromJson(Map<String, dynamic> json) {
    return ColorModel(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
    );
  }
}
class HostCarShareModel {
  final int id;
  final String name;

  HostCarShareModel({required this.id, required this.name});

  factory HostCarShareModel.fromJson(Map<String, dynamic> json) {
    return HostCarShareModel(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
    );
  }
}













// create api for add car
class VehicleCreateModel {
  int userId;
  int vehicleId;
  String trim;
  int color;
  String rideTypes;
  String greenCarId;
  bool isDefault;
  String licensePlateNum;

  VehicleCreateModel({
    required this.userId,
    required this.vehicleId,
    required this.trim,
    required this.color,
    required this.rideTypes,
    required this.greenCarId,
    required this.isDefault,
    required this.licensePlateNum,
  });

  Map<String, String> toFields() {
    return {
      "user_id": userId.toString(),
      "vehicle_id": vehicleId.toString(),
      "trim": trim,
      "color": color.toString(),
      "ride_types": rideTypes,
      "green_car_id": greenCarId,
      "is_default": isDefault.toString(),
      "license_plate_num": licensePlateNum,
    };
  }
}





// search model for Car model
// ----------------------------------------------------------
// 📌 MODEL: VehicleModel
// ----------------------------------------------------------
// This model represents each vehicle returned from the API:
// [
//   {
//     "id": 51588,
//     "name": "2023 Tesla Model Y",
//     "vehicle_type": "SUV",
//     "num_seats4riders": 4,
//     "is_lux": false,
//     "trim": "",
//     "ride_types": "1,3",
//     "green_car_type": "E"
//   }
// ]
// ----------------------------------------------------------
class VehicleModel {
  final int id;
  final String name;
  //final VehicleType;
  //final int numSeats4Riders;
  //final bool isLux;
  //final String trim;
  //final String rideTypes;
  //final String greenCarType;

  VehicleModel({
    required this.id,
    required this.name,
    // required this.vehicleType,
    // required this.numSeats4Riders,
    // required this.isLux,
    // required this.trim,
    // required this.rideTypes,
    // required this.greenCarType,

  });

  // convert JSON - Model
factory VehicleModel.fromJson(Map<String, dynamic> json){
  return VehicleModel(
    id: json["id"],
    name: json["name"] ?? "",
    // Future fields (commented):
    // vehicleType: json["vehicle_type"] ?? "",
    // numSeats4Riders: json["num_seats4riders"] ?? 0,
    // isLux: json["is_lux"] ?? false,
    // trim: json["trim"] ?? "",
    // rideTypes: json["ride_types"] ?? "",
    // greenCarType: json["green_car_type"] ?? "",

    );
}
}


// car share model ( share car to set active)

class CarShareVehicleModel {
  final int id;
  final int userId;
  final int vehicleId;
  final String? trim;
  final String? rideTypes;
  final bool isActive;
  final bool isBooked;
  final int metroId;
  final int? hourlyCost;
  final int? dailyCost;
  final int? weeklyCost;
  final String address;
  final String lat;
  final String long;
  final String prefsSel;

  CarShareVehicleModel({
    required this.id,
    required this.userId,
    required this.vehicleId,
    this.trim,
    this.rideTypes,
    required this.isActive,
    required this.isBooked,
    required this.metroId,
    this.hourlyCost,
    this.dailyCost,
    this.weeklyCost,
    required this.address,
    required this.lat,
    required this.long,
    required this.prefsSel,
  });


  factory CarShareVehicleModel.fromJson(Map<String, dynamic> json) {
    return CarShareVehicleModel(
      id: json['id'],
      userId: json['user_id'],
      vehicleId: json['vehicle_id'],
      trim: json['trim'],
      rideTypes: json['ride_types'],
      isActive: json['is_active'] ?? false,
      isBooked: json['is_booked'] ?? false,
      metroId: json['metro_id'],
      hourlyCost: json['hourly_cost'],
      dailyCost: json['daily_cost'],
      weeklyCost: json['weekly_cost'],
      address: json['address'],
      lat: json['lat'],
      long: json['long'],
      prefsSel: json['prefs_sel'],
    );
  }
}





// Thid is for recomanded cars showing in carsharing users screen

class CarSharingResponse {
  final List<CarItem> jsonAgg;

  CarSharingResponse({required this.jsonAgg});

  factory CarSharingResponse.fromJson(Map<String, dynamic> json) {
    return CarSharingResponse(
      jsonAgg: (json['json_agg'] as List<dynamic>)
          .map((e) => CarItem.fromJson(e))
          .toList(),
    );
  }
}


class CarItem {
  final int id;
  final int? userId;
  final String? address;
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

  final VehicleInfo? vehicle;
  final bool? isNewlyAdded;

  CarItem({
    required this.id,
    this.userId,
    this.address,
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
  });

  factory CarItem.fromJson(Map<String, dynamic> json) {
    return CarItem(
      id: json["id"],
      userId: json["user_id"],
      vehicleId: json["vehicle_id"],
      address: json["address"],
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





