import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';
import 'package:us_building_client/data/models/service_model.dart';

import '../../core/failure/failure.dart';
import '../../services/network_service.dart';
import '../static/enum/database_table_enum.dart';

class ServiceRepository {
  Future<Either<Failure, List<ServiceModel>>> getServiceLv1List() async {
    try {
      List<ServiceModel>? serviceList;

      final response = await NetworkService.get(
        queryParam: {
          'tablename': DatabaseTableEnum.tbl_com_01_us_01_dvcap1.name,
        },
        url: '/list/',
      );

      response.fold(
        (failure) => null,
        (data) {
          List<dynamic> jsonList = data;

          serviceList =
              jsonList.map((json) => ServiceModel.fromJson(json)).toList();
        },
      );

      return serviceList == null
          ? const Left(ApiFailure('Không có dữ liệu'))
          : Right(serviceList!);
    } catch (e, stackTrace) {
      debugPrint(
        'Caught getting service lv1 list error: ${e.toString()} \n${stackTrace.toString()}',
      );

      return Left(ExceptionFailure(e.toString()));
    }
  }
}
