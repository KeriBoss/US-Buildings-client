import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:us_building_client/core/extension/number_extension.dart';
import 'package:us_building_client/data/models/service_model.dart';

import '../../data/static/app_value.dart';
import '../../utils/ui_render.dart';

class ServiceListItem extends StatefulWidget {
  const ServiceListItem({super.key, required this.service});

  final ServiceModel service;

  @override
  State<StatefulWidget> createState() => _ServiceListItemState();
}

class _ServiceListItemState extends State<ServiceListItem> {
  bool isLiked = false;

  void _selectService() {}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _selectService,
      child: Container(
        height: 70.size,
        margin: EdgeInsets.symmetric(vertical: 7.height),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(100.radius),
          border: Border.all(color: Theme.of(context).colorScheme.primary),
        ),
        child: Row(
          children: [
            ClipOval(
              child: UiRender.networkImage(
                AppValue.commonImgUrl + widget.service.iconUrl!,
                height: 70.size,
                width: 70.size,
              ),
            ),
            8.horizontalSpace,
            Expanded(
              flex: 7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.service.serviceName!,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 16.size,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 7.width),
                    child: Text(
                      widget.service.description!,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 12.size,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 7.width),
                    child: Text(
                      '${widget.service.price!} VNĐ',
                      style: TextStyle(
                        fontSize: 14.size,
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    isLiked = !isLiked;
                  });
                },
                iconSize: 20.size,
                icon: ImageIcon(
                  const AssetImage('assets/icons/heart.png'),
                  color: isLiked
                      ? Colors.red
                      : Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ),
            const Icon(Icons.add),
            15.horizontalSpace,
          ],
        ),
      ),
    );
  }
}
