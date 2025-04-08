import 'package:Skillify/src/res/colors/colors.dart';
import 'package:Skillify/src/res/dimentions/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';


class CurrentMonthdate extends StatefulWidget {
  final void Function(DateTime)? onDateChange;
  final Map<DateTime, List<String>> events;

  CurrentMonthdate(
      {super.key, required this.onDateChange, required this.events});

  @override
  State<CurrentMonthdate> createState() => _CurrentMonthdateState();
}

class _CurrentMonthdateState extends State<CurrentMonthdate> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<String> _getEventsForDay(DateTime day) {
    return widget.events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TableCalendar(
          startingDayOfWeek: StartingDayOfWeek.monday,
          headerStyle: HeaderStyle(
            formatButtonVisible: true,
            titleCentered: true,
            titleTextStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
            rightChevronIcon: Icon(Icons.arrow_forward_ios,
                color: Theme.of(context).brightness.name == 'light'
                    ? AppColors.blackColor
                    : Theme.of(context).colorScheme.onError),
            leftChevronIcon: Icon(Icons.arrow_back_ios,
                color: Theme.of(context).brightness.name == 'light'
                    ? AppColors.blackColor
                    : Theme.of(context).colorScheme.onError),
            formatButtonTextStyle:
                Theme.of(context).textTheme.bodyMedium!.copyWith(),
          ),
          availableGestures: AvailableGestures.all,
          focusedDay: _focusedDay,
          lastDay: DateTime.utc(2030, 3, 30),
          firstDay: DateTime.utc(2020, 1, 1),
          calendarFormat: _calendarFormat,
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: AppDimensions.ratio * 9.5),
            weekendStyle: TextStyle(
                color: Theme.of(context).hintColor,
                fontWeight: FontWeight.bold,
                fontSize: AppDimensions.ratio * 9.5),
          ),
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
            if (widget.onDateChange != null) {
              widget.onDateChange!(selectedDay);
            }
          },
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          calendarStyle: CalendarStyle(
              selectedDecoration: ShapeDecoration(
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Theme.of(context).primaryColor),
                ),
              ),
              todayDecoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Theme.of(context).primaryColor),
                ),
              ),
              selectedTextStyle:
                  TextStyle(color: Theme.of(context).colorScheme.onError),
              todayTextStyle:
                  Theme.of(context).textTheme.bodyMedium ?? TextStyle(),
              markerDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                shape: BoxShape.circle,
              ),
              markerSize: AppDimensions.ratio * 2),
          eventLoader: _getEventsForDay,
        ),
      ],
    );
  }
}
