import 'package:Skillify/src/res/colors/colors.dart';
import 'package:Skillify/src/res/style/app_typography.dart';
import 'package:Skillify/src/res/style/text_style.dart';
import 'package:flutter/material.dart';


class CustomDropDown extends StatelessWidget {
  final String? value;
  final String title;
  final List<String> items;
  final void Function(String?) onChanged;
  CustomDropDown(
      {super.key,
      this.value,
      required this.title,
      required this.items,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      icon: Icon(Icons.keyboard_arrow_down),
      iconEnabledColor: AppColors.primaryColor,
      isExpanded: true,
      isDense: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.onSecondary),
            borderRadius: BorderRadius.circular(10.0)),
        hintText: title,
        filled: true,
        hintStyle: TextStyles.l1!.copyWith(),
        fillColor: Theme.of(context).colorScheme.surface,
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).colorScheme.onSecondary),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).colorScheme.onSecondary),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      style: Theme.of(context).textTheme.bodySmall,
      dropdownColor: Theme.of(context).indicatorColor,
      borderRadius: BorderRadius.circular(10.0),
      value: value,
      onChanged: onChanged,
      items: items.map(
        (String value) {
          return DropdownMenuItem(
            value: value,
            child: textStyle(
              text: value,
              style: TextStyles.b3!.copyWith(fontWeight: FontWeight.w400),
            ),
          );
        },
      ).toList(),
    );
  }
}
