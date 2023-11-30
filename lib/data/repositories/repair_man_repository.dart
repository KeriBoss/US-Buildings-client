import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';
import 'package:us_building_client/data/models/repair_man_model.dart';

import '../../core/failure/failure.dart';
import '../../services/network_service.dart';
import '../static/enum/database_table_enum.dart';

class RepairManRepository {
  Future<Either<Failure, List<RepairManModel>>> getRepairMenList({
    Map<String, dynamic>? queryMap,
  }) async {
    try {
      List<RepairManModel>? repairMenList;

      Map<String, dynamic> queryParams = {
        'tablename': DatabaseTableEnum.tbl_com_01_us_14_taotho.name,
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

          repairMenList =
              jsonList.map((json) => RepairManModel.fromJson(json)).toList();
        },
      );

      return repairMenList == null
          ? const Left(ApiFailure('Không có dữ liệu'))
          : Right(repairMenList!);
    } catch (e, stackTrace) {
      debugPrint(
        'Caught getting repair men list error: ${e.toString()} \n${stackTrace.toString()}',
      );

      return Left(ExceptionFailure(e.toString()));
    }
  }
}
