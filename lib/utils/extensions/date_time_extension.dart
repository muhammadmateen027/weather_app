extension DateTimeString on DateTime {
  String get fullDayName {
    switch (weekday) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return '';
    }
  }

  String get shortDayName => fullDayName.substring(0, 3);

  String get formattedTime {
    final hour = this.hour > 12 ? this.hour - 12 : this.hour;
    final adjustedHour = hour == 0 ? 12 : hour;
    final minute = this.minute.toString().padLeft(2, '0');
    final period = this.hour >= 12 ? 'PM' : 'AM';

    return '$adjustedHour:$minute $period';
  }

  String get formattedDate {
    final day = this.day.toString().padLeft(2, '0');
    final month = this.month.toString().padLeft(2, '0');
    final year = this.year;

    return '$day/$month/$year';
  }
}
