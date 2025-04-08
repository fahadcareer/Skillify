// ignore_for_file: must_be_immutable

import 'package:Skillify/src/res/colors/colors.dart';
import 'package:Skillify/src/res/dimentions/app_dimensions.dart';
import 'package:Skillify/src/res/style/app_typography.dart';
import 'package:Skillify/src/res/style/text_style.dart';
import 'package:Skillify/src/widgets/cus_container.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onPressed;
  final BuildContext context;
  final String txt;
  final double? width;
  Color? prime;
  final Color? txtColor;
  final Color? borderColor;
  CustomButton({
    super.key,
    required this.onPressed,
    required this.context,
    required this.txt,
    this.width = double.infinity,
    this.prime,
    this.txtColor = AppColors.whiteColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    if (prime == null) {
      prime = Theme.of(context).primaryColor;
    } else {
      prime = prime;
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: prime,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: borderColor ?? prime!)),
        elevation: 0,
      ),
      onPressed: onPressed,
      child: CustomContainer(
        width: width,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: AppDimensions.space(0.9)),
            child: textStyle(
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              text: txt,
              style: TextStyles.b3!.copyWith(color: txtColor),
            ),
          ),
        ),
      ),
    );
  }
}

// Widget CustomButton(context:context,
//     {required void Function()? onPressed,
//     required String txt,
//     double? width = double.infinity,
//     Color? primary = AppColors.primaryColor,
//     Color? txtColor = AppColors.whiteColor}) {

// }
