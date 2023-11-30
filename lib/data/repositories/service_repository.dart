import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';
import 'package:us_building_client/data/models/service_model.dart';
import 'package:us_building_client/data/models/service_order_model.dart';
import 'package:us_building_client/utils/value_render.dart';

import '../../core/failure/failure.dart';
import '../../core/success/success.dart';
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
        'Caught getting service list error: ${e.toString()} \n${stackTrace.toString()}',
      );

      return Left(ExceptionFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<ServiceOrderModel>>> getServiceOrderModelList({
    Map<String, dynamic>? queryMap,
  }) async {
    try {
      List<ServiceOrderModel>? serviceOrderList;

      Map<String, dynamic> queryParams = {
        'tablename': DatabaseTableEnum.tbl_com_01_us_10_donhang.name,
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

          serviceOrderList =
              jsonList.map((json) => ServiceOrderModel.fromJson(json)).toList();
        },
      );

      return serviceOrderList == null
          ? const Left(ApiFailure('Không có dữ liệu'))
          : Right(serviceOrderList!);
    } catch (e, stackTrace) {
      debugPrint(
        'Caught getting service order list error: ${e.toString()} \n${stackTrace.toString()}',
      );

      return Left(ExceptionFailure(e.toString()));
    }
  }

  Future<Either<Failure, Success>> createNewServiceOrder(
    ServiceOrderModel serviceOrder,
  ) async {
    bool isSuccess = false;

    try {
      Map<String, dynamic> requestParam = ValueRender.requestBodyForNewData(
        DatabaseTableEnum.tbl_com_01_us_10_donhang,
        serviceOrder.toJson(),
      );

      final response = await NetworkService.post(
        paramBody: requestParam,
        url: '/krud/',
      );

      response.fold(
        (failure) => isSuccess = false,
        (success) => isSuccess = true,
      );

      return isSuccess
          ? const Right(ApiSuccessMessage('Tạo đơn hàng mới thành công'))
          : const Left(ApiFailure('Tạo đơn hàng mới thất bại'));
    } catch (e, stackTrace) {
      debugPrint(
        'Caught creating new service order error: ${e.toString()} \n${stackTrace.toString()}',
      );

      return Left(ExceptionFailure(e.toString()));
    }
  }
}
