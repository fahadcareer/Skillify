import 'package:flutter/material.dart';

Future bottomSheet(
    {required BuildContext context, Widget? widget, WidgetBuilder? builder}) {
  return showModalBottomSheet(
    isScrollControlled: true,
    useRootNavigator: false,
    barrierColor: Colors.transparent,
    clipBehavior: Clip.hardEdge,
    context: context,
    builder: (context) => builder != null
        ? builder(context)
        : Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: widget,
          ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(50),
        topRight: Radius.circular(50),
      ),
    ),
    elevation: 5,
  );
}
