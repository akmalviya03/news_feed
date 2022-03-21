class DateFormatter {
  String formatMyDate(String dateInUTC) {
    Duration _dateDifference =
        DateTime.now().difference(DateTime.parse(dateInUTC));
    if ((_dateDifference.inHours) < 24) {
      if (_dateDifference.inHours > 1) {
        return _dateDifference.inHours.toString() + 'hours ago';
      } else {
        return _dateDifference.inHours.toString() + 'hour ago';
      }
    } else if ((_dateDifference.inDays) < 7) {
      if (_dateDifference.inDays > 1) {
        return _dateDifference.inDays.toString() + 'days ago';
      } else {
        return _dateDifference.inDays.toString() + 'day ago';
      }
    } else if ((_dateDifference.inDays) < 31) {
      int weeks = _dateDifference.inDays ~/ 7;
      if (_dateDifference.inDays > 1) {
        return weeks.toString() + 'weeks ago';
      } else {
        return weeks.toString() + 'week ago';
      }
    } else if ((_dateDifference.inDays) < 365) {
      int months = _dateDifference.inDays ~/ 30;
      if (_dateDifference.inDays > 1) {
        return months.toString() + 'months ago';
      } else {
        return months.toString() + 'month ago';
      }
    } else {
      int years = _dateDifference.inDays ~/ 365;
      if (_dateDifference.inDays > 1) {
        return years.toString() + 'years ago';
      } else {
        return years.toString() + 'year ago';
      }
    }
  }
}
