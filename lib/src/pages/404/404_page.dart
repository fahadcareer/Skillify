import 'package:Skillify/src/data/local/cache_helper.dart';
import 'package:Skillify/src/res/drawable/drawables.dart';
import 'package:Skillify/src/res/style/text_style.dart';
import 'package:Skillify/src/widgets/cus_appbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(c: context),
      body: Column(
        children: [
          Center(
            child: Lottie.asset(SkillAssessmentAssetsFile.error),
          ),
          InkWell(
            onTap: () async =>
                await CacheHelper.clearData().then((value) => context.go('/')),
            child: textStyle(
              text: 'LogOut',
            ),
          ),
        ],
      ),
    );
  }
}
