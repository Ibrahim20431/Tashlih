String formatDate(DateTime dateTime) {
  final dateYear = dateTime.year;
  final dateMonth = dateTime.month;
  final dateDay = dateTime.day;
  final dateHour = dateTime.hour;

  final now = DateTime.now();
  final nowDay = now.day;

  if (now.year == dateYear && now.month == dateMonth) {
    if (nowDay == dateDay) {
      if (dateHour > 11) {
        return 'الليلة';
      } else {
        return 'اليوم';
      }
    } else if (nowDay - dateDay == 1) {
      if (dateHour < 12) {
        return 'أمس';
      } else {
        return 'البارحة';
      }
    } else {
      return '$dateYear/$dateMonth/$dateDay';
    }
  } else {
    return '$dateYear/$dateMonth/$dateDay';
  }
}

String formatTime(DateTime date) {
  final h = date.hour;
  final mm = date.minute.toString().padLeft(2, '0');
  if (h > 12) {
    final hh = (h - 12).toString().padLeft(2, '0');
    return '$hh:$mm م';
  } else if (h == 12) {
    return '12:$mm م';
  } else if (h > 0) {
    final hh = h.toString().padLeft(2, '0');
    return '$hh:$mm ص';
  } else {
    return '12:$mm ص';
  }
}
