import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:unifi_solutions/core/utils/theme/colors_manager.dart';
import 'package:unifi_solutions/core/utils/theme/values_manager.dart';
import '../constants/enums/toast_status.dart';

class AppToast {
  static showToast({
    required String description,
    required ToastStatus status,
    required BuildContext context,
  }) {
    showToastWidget(
      textDirection:TextDirection.ltr,
      duration: const Duration(seconds: 5),
      context: context,
      ToastWidget(
        lineColor: status.toastColor,
        title: status.toastTitle,
        icon: status.toastIcon,
        description: description,
      ),
    );
  }
}

class ToastWidget extends StatelessWidget {
  const ToastWidget({
    super.key,
    required this.lineColor,
    required this.description,
    required this.title,
    required this.icon,
  });
  final Color lineColor;
  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SlideInDown(
      child: Stack(
        children: [
          Align(
            alignment: AlignmentDirectional.topCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: REdgeInsets.all(AppMargin.m12),
                  padding: REdgeInsets.symmetric(
                      horizontal: AppPadding.p12, vertical: AppPadding.p6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light
                        ? ColorsManager.white
                        : const Color(0XFF2E2E2E),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        Container(
                          width: AppSize.s6,
                          decoration: BoxDecoration(
                            color: lineColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        8.horizontalSpace,
                        CircleAvatar(
                          radius: 16.r,
                          backgroundColor: lineColor,
                          child: Icon(
                            icon,
                            color: ColorsManager.white,
                          ),
                        ),
                        Flexible(
                          child: ListTile(
                            title: Row(
                              children: [
                                Text(
                                  title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color:Theme.of(context).primaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Padding(
                              padding: REdgeInsets.only(top: 0),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: description.split('\n').map((line) {
                                    return Text(
                                      line,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: AppPadding.p10,
            top: AppPadding.p10,
            child: ZoomIn(
              delay: const Duration(milliseconds: 500),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.cancel,
                  color: lineColor,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
