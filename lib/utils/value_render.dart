import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:us_building_client/data/static/enum/database_table_enum.dart';

class ValueRender {
  ValueRender._();

  static final instance = ValueRender._();

  static String convertImageToBase64(File imageFile) {
    final Uint8List bytes = imageFile.readAsBytesSync();
    String imgBase64 = base64Encode(bytes);
    return imgBase64;
  }

  static String randomPhoneNumber() {
    const chars = '1234567890';
    Random rnd = Random();

    return String.fromCharCodes(
      Iterable.generate(
        8,
        (_) => chars.codeUnitAt(
          rnd.nextInt(chars.length),
        ),
      ),
    );
  }

  static String getFileExtension(String fileName) {
    return ".${fileName.split('.').last}";
  }

  static Map<String, dynamic> requestBodyForNewData(
    DatabaseTableEnum table,
    Map<String, dynamic> body,
  ) {
    Map<String, dynamic> requestParam = {
      'tablename': table.name,
      DatabaseActionEnum.submitnew.name: DatabaseActionEnum.submitnew.name,
    }..addAll(body);

    return requestParam;
  }
}
