import 'package:Skillify/src/res/colors/colors.dart';
import 'package:flutter/material.dart';


Widget userStatus(int status) {
  return Container(
    width: 15,
    height: 15,
    decoration: BoxDecoration(
        color: status == 1
            ? AppColors.greenColor
            : status == 2
                ? AppColors.lightGreenColor
                : AppColors.grayColor,
        shape: BoxShape.circle),
  );
}
