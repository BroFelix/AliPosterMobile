import 'package:ali_poster/theme/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class AppTextStyle {
  static const TextStyle homePageTitleStyle = TextStyle(
    fontSize: 24,
    color: AppColors.white,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle dateTimeStyle = TextStyle(
    fontSize: 22.0,
    color: AppColors.white,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle appBarTitle = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle orderTextStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    color: AppColors.white,
  );

  static const TextStyle costPresentStyle = TextStyle(
    fontSize: 24,
    color: AppColors.white,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle userNameStyle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle splashText = TextStyle(
    fontSize: 18.0,
    color: AppColors.white,
    fontWeight: FontWeight.w500,
  );
}
