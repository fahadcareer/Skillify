import 'package:Skillify/src/res/drawable/drawables.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class CustomImg extends StatelessWidget {
  String image;
  double? width;
  double? height;
  CustomImg({super.key, required this.image, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image,
      width: width,
      height: height,
      progressIndicatorBuilder: (context, string, process) =>
          CircularProgressIndicator(value: process.progress),
      errorWidget: (context, error, stacktrace) =>
          Lottie.asset(SkillAssessmentAssetsFile.error),
      fit: BoxFit.cover,
    );
  }
}
