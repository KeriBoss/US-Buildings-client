import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';
import 'package:us_building_client/data/models/service_model.dart';

import '../../core/failure/failure.dart';
import '../../services/network_service.dart';
import '../static/enum/database_table_enum.dart';

class ServiceRepository {
  Future<Either<Failure, List<ServiceModel>>> getServiceModelList(
    DatabaseTableEnum databaseTable, {
    Map<String, dynamic>? queryMap,
  }) async {
    try {
      List<ServiceModel>? serviceList;

      Map<String, dynamic> queryParams = {
        'tablename': databaseTable.name,
      };

      if (queryMap != null) {
        queryParams.addAll(queryMap);
      }

      final response = await NetworkService.get(
        queryParam: queryParams,
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
