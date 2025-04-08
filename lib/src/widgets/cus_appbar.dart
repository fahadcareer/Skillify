import 'package:Skillify/src/res/dimentions/space.dart';
import 'package:Skillify/src/res/style/app_typography.dart';
import 'package:Skillify/src/res/style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool backButton;
  final bool searchButton;
  final BuildContext c;
  final void Function()? onTap;
  final String? title;

  CustomAppBar({
    super.key,
    this.backButton = false,
    this.searchButton = false,
    this.onTap,
    required this.c,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      centerTitle: true,
      leading: backButton
          ? Padding(
              padding: Space.v ?? EdgeInsets.zero,
              child: GestureDetector(
                onTap: () {
                  c.pop();
                },
                child: Material(
                  type: MaterialType.circle,
                  color: Theme.of(context).primaryColor,
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: Theme.of(context)
                        .floatingActionButtonTheme
                        .foregroundColor,
                  ),
                ),
              ),
            )
          : null,
      title: GestureDetector(
        onTap: onTap,
        child: textStyle(
          text: '$title',
          style: (TextStyles.b2 ?? const TextStyle()).copyWith(
            color: Theme.of(context).floatingActionButtonTheme.foregroundColor,
          ),
        ),
      ),
      elevation: 0.5,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
