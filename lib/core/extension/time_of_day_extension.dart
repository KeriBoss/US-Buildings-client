import 'package:flutter/material.dart';

extension TimeOfDayExtenstion on TimeOfDay {
  int get toMinutes => (hour * 60) + minute;
}
