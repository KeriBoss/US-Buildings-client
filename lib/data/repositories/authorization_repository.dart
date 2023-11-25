import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';

import '../../core/failure/failure.dart';
import '../../core/success/success.dart';
import '../../services/local_storage_service.dart';
import '../../services/network_service.dart';
import '../models/user.dart';
import '../static/enum/database_table_enum.dart';
import '../static/enum/local_storage_enum.dart';

class AuthorizationRepository {
  Future<Either<Failure, User>> login(
    String phoneNumber,
    String password,
  ) async {
    try {
      User? user;

      final response = await NetworkService.get(
        queryParam: {
          'tablename': DatabaseTableEnum.tbl_com_yume_nhansu.name,
          'fieldname': 'phonenumber',
          'fieldvalue': phoneNumber,
          'fieldname': 'password',
          'password': password,
        },
        url: '/list/',
      );

      response.fold(
        (failure) => null,
        (success) {
          Map<String, dynamic> resMap = jsonDecode(success.toString());
          user = User.fromJson(resMap);
        },
      );

      if (user != null) {
        String? rememberPass = await LocalStorageService.getLocalStorageData(
            LocalStorageEnum.rememberLogin.name) as String?;

        if (rememberPass != null && rememberPass == 'true') {
          LocalStorageService.setLocalStorageData(
            LocalStorageEnum.phoneNumber.name,
            user!.phoneNumber,
          );
          LocalStorageService.setLocalStorageData(
            LocalStorageEnum.password.name,
            user!.password,
          );
        }

        return Right(user!);
      } else {
        return const Left(ApiFailure('Tài khoản này không tồn tại'));
      }
    } catch (e, stackTrace) {
      debugPrint(
        'Caught login error: ${e.toString()} \n${stackTrace.toString()}',
      );

      return Left(ExceptionFailure(e.toString()));
    }
  }

  Future<Either<Failure, Success>> register(User newUser) async {
    bool isSuccess = false;

    try {
      Map<String, dynamic> requestParam = {
        'tablename': DatabaseTableEnum.tbl_com_yume_nhansu.name,
        DatabaseActionEnum.submitnew.name: DatabaseActionEnum.submitnew.name,
      }..addAll(newUser.toJson());

      String fcmToken = await LocalStorageService.getLocalStorageData(
        LocalStorageEnum.phoneToken.name,
      ) as String;

      requestParam['fcmtoken'] = fcmToken;

      final res = await NetworkService.post(
        paramBody: requestParam,
        url: '/krud/',
      );

      res.fold(
        (failure) => isSuccess = false,
        (success) => isSuccess = true,
      );

      // final response = await NetworkService.get(
      //   queryParam: {
      //     'tablename': DatabaseTableEnum.tbl_users.name,
      //     'fieldname': 'phonenumber',
      //     'fieldvalue': newUser.phoneNumber,
      //   },
      //   url: '/list/',
      // );
      //
      // response.fold(
      //   (failure) async {
      //     Map<String, dynamic> requestParam = {
      //       'tablename': DatabaseTableEnum.tbl_users.name,
      //       DatabaseActionEnum.submitnew.name:
      //           DatabaseActionEnum.submitnew.name,
      //     }..addAll(newUser.toJson());
      //
      //     String fcmToken = await LocalStorageService.getLocalStorageData(
      //       LocalStorageEnum.phoneToken.name,
      //     ) as String;
      //
      //     requestParam['phoneFcmToken'] = fcmToken;
      //
      //     final res = await NetworkService.post(
      //       paramBody: requestParam,
      //       url: '/krud/',
      //     );
      //
      //     res.fold(
      //       (failure) => isSuccess = false,
      //       (success) => isSuccess = true,
      //     );
      //   },
      //   (success) {
      //     isSuccess = false;
      //   },
      // );
      //
      return isSuccess
          ? const Right(ApiSuccessMessage('Đăng ký tài khoản mới thành công'))
          : const Left(ApiFailure('Tài khoản này đã tồn tại'));
    } catch (e, stackTrace) {
      debugPrint(
        'Caught register error: ${e.toString()} \n${stackTrace.toString()}',
      );

      return Left(ExceptionFailure(e.toString()));
    }
  }
}
