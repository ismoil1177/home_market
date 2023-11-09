import 'package:home_market/services/constants/app_icons.dart';

bool fromIsLiked = false;
List<String> icons = [
  AppIcons.home,
  AppIcons.location,
  AppIcons.favoriteOut,
  AppIcons.account
];

List<String> facilitiesIcons = [
  AppIcons.car,
  AppIcons.swim,
  AppIcons.gym,
  AppIcons.restaurant,
  AppIcons.wifi,
  AppIcons.pet,
  AppIcons.sports,
  AppIcons.laundry,
];

List<String> facilitiesName = [
  "Car Parking",
  "Swimming",
  "Gym & Fit",
  "Restaurant",
  "Wi-fi",
  "Pet Center",
  "Sports",
  "Laundry",
];

class LatLong {
  static double? lat;
  static double? long;
}
