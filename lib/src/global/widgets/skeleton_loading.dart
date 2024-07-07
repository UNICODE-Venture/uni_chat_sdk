import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uni_chat_sdk/src/core/extension/extenstion.dart';

import '../../theme/colors.dart';

final _colors = ColorsPalletes.instance;

class SkeletonLoading extends StatelessWidget {
  final double? width;
  final double? height;
  final bool isCircleShape;
  final BorderRadius? borderRadius;

  /// [SkeletonLoading] is the loading widget that is displayed while the data is being fetched
  const SkeletonLoading({
    super.key,
    this.width = 0,
    this.height = 0,
    this.isCircleShape = false,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: _colors.grey20,
      highlightColor: _colors.lightDark06,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: isCircleShape ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircleShape ? null : borderRadius ?? 10.br,
        ),
      ),
    );
  }
}
