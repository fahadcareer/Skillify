// ignore_for_file: must_be_immutable

import 'package:Skillify/src/res/style/app_typography.dart';
import 'package:Skillify/src/res/style/text_style.dart';
import 'package:Skillify/src/widgets/image_widget.dart';
import 'package:flutter/material.dart';


class CusClip extends StatelessWidget {
  String img;
  String name;
  CusClip({super.key, required this.img, required this.name});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: ClipOval(
        child: CustomImg(image: img),
      ),
      label: textStyle(
        text: name,
        style: TextStyles.l1,
      ),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).primaryColor,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
