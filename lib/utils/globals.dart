import 'package:flutter/material.dart';
import 'package:women_safety_app/models/product.dart';
import 'package:women_safety_app/models/user.dart';
import 'package:women_safety_app/repo/auth_repo.dart';
import 'package:women_safety_app/repo/location_repo.dart';
import 'package:women_safety_app/repo/order_repo.dart';
import 'package:women_safety_app/repo/product_repo.dart';
import 'package:women_safety_app/repo/user_repo.dart';
import 'package:women_safety_app/repo/video_repo.dart';

final UserRepo userRepo = UserRepo();
final AuthRepo authRepo = AuthRepo();
final ProductRepo productRepo = ProductRepo();
final LocationRepo locations = LocationRepo();
final OrderRepo orderRepo = OrderRepo();
final VideoRepo videoRepo = VideoRepo();

String? notifToken;
User? currentUserGlobal;
ValueNotifier<List<StoreProduct>> cart = ValueNotifier([]);
const MediaQueryData? size = const MediaQueryData();
// String? currentUser;

final ThemeData bridgeLinxTheme = ThemeData(
  primarySwatch: Colors.blueGrey,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  fontFamily: 'Avenir',
  textTheme: const TextTheme(
    bodyText2: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      // height: 1.416,
    ),
    bodyText1: TextStyle(
      fontSize: 18,
      fontFamily: 'Avenir',
      // fontStyle: FontStyle.normal,
      fontWeight: FontWeight.normal,
    ),
    button: TextStyle(
      color: Colors.white,
      fontSize: 18,
      height: 0.811,
      fontWeight: FontWeight.bold,
    ),
    // body heading
    headline1: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w900,
      // height: 1.416,
      // color: AppColors.primaryColor,
    ),
    headline2: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      height: 1.416,
      fontFamily: 'Avenir',
    ),
    headline4: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 0.916,
      fontFamily: 'Avenir',
    ),
    headline5: TextStyle(
      fontFamily: 'Avenir',
      fontSize: 18,
      height: 1.096,
      color: AppColors.prominent,
      fontWeight: FontWeight.w700,
    ),
  ),
);

class AppColors {
  // static const Color primaryColor = Color(0xFF1C75BC);
  static const MaterialColor primaryColor = Colors.blueGrey;

  static const Color primaryTint = Color(0xFF3F9AE2);
  static const Color primaryShade = Color(0xFF15588D);
  static const Color secondaryColor = Color(0xFF00C2CB);
  static const Color secondaryShade = Color(0xFF009298);
  static const Color secondaryTint = Color(0xFF00E7F1);
  static const Color backgroundTint = Color(0x0F1C75BC);
  static const Color boxHighlight = Color(0xFFEDF7FF);
  static const Color boxOutlines = Color(0xFFC4C4C4);
  static const Color prominent = Color(0xff3C3C3C);
  static const Color warningMain = Color(0xffFF6883);
  static const Color selectedBox = Color(0xff71b1e3);
  static const Color baseBackgroundColor = Color(0xffF5F5F5);
  static const Color financeBlue = Color(0xff013365);
  static const Color financeBlueShadow = Color(0x8C013365);
}
