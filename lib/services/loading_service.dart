import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/service/service_bloc.dart';

class LoadingService {
  final BuildContext context;
  LoadingService(this.context);

  Future<void> reloadHomePage() async {
    context.read<ServiceBloc>().add(OnLoadServiceLv1ListEvent());
  }

  Future<void> reloadServiceListPage(String serviceLv2Name) async {
    context.read<ServiceBloc>().add(OnLoadServiceListEvent(serviceLv2Name));
  }
}
