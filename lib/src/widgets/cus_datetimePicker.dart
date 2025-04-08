// ignore: file_names
import 'package:Skillify/src/res/dimentions/app_dimensions.dart';
import 'package:flutter/cupertino.dart';


DateTime selectedDate = DateTime.now();

// ignore: non_constant_identifier_names
Widget CustomDateTimePicker({
  required void Function(DateTime) onDateTimeChanged,
  CupertinoDatePickerMode mode = CupertinoDatePickerMode.dateAndTime,
  DateTime? minimumDate,
  onTap,
}) {
  return GestureDetector(
    onTap: () {
      DateTime.now();
      onDateTimeChanged(selectedDate);
    },
    child: SizedBox(
      height: AppDimensions.space(25),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppDimensions.space(0.1),
          horizontal: AppDimensions.space(0.1),
        ),
        child: IntrinsicHeight(
          child: CupertinoDatePicker(
            initialDateTime: selectedDate,
            onDateTimeChanged: onDateTimeChanged,
            minimumDate: minimumDate,
            // onDateTimeChanged: (DateTime newDate) {
            //   selectedDate = newDate.toUtc();
            // },
            minimumYear: 2023,
            maximumYear: 2050,
            mode: mode,
          ),
        ),
      ),
    ),
  );
}
