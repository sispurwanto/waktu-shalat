import 'package:hijri/hijri_calendar.dart';
void main() {
  HijriCalendar.setLocal('ar');
  var today = HijriCalendar.now();
  print(today.toFormat("dd MMMM yyyy"));
}
