// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ShimmerWidget extends StatelessWidget {
  ShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SpinKitFadingCircle(
      color: Theme.of(context).colorScheme.onPrimary,
      size: 50.0,
    );
  }
}
