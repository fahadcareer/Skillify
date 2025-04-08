import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomSVG extends StatelessWidget {
  final String svg;
  final Color? color;
  final double? size;

  CustomSVG({super.key, required this.svg, this.color, this.size});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      svg,
      color: color,
      width: size,
      height: size,
    );
  }
}

class CustomNetSVG extends StatelessWidget {
  final String url;
  final Color? color;
  final double? size;

  CustomNetSVG({super.key, required this.url, this.color, this.size});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.network(
      url,
      color: color,
      width: size,
      height: size,
    );
  }
}
