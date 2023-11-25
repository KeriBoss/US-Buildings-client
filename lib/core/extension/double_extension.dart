import 'package:flutter/cupertino.dart';
import 'package:us_building_client/core/extension/number_extension.dart';

extension SpaceWidget on double {
  Widget get horizontalSpace => SizedBox(height: width.width);
  Widget get verticalSpace => SizedBox(height: height.height);
}
