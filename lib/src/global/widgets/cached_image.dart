import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../uni_design.dart';
import 'skeleton_loading.dart';

final _designSystem = UniDesignSystem.instance;

class CachedImageView extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final int? memCacheHeight;
  final int? maxWidthDiskCache;
  final int? maxHeightDiskCache;
  final int? memCacheWidth;
  final BoxFit? fit;
  final Widget Function(ImageProvider)? imgBuilder;
  final bool isCircleShape;
  final BorderRadiusGeometry? borderRadius;
  final Widget? errorWidget;

  const CachedImageView({
    super.key,
    required this.url,
    this.imgBuilder,
    this.width,
    this.height,
    this.memCacheHeight,
    this.maxWidthDiskCache,
    this.maxHeightDiskCache,
    this.memCacheWidth,
    this.fit,
    this.isCircleShape = false,
    this.borderRadius,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,
      memCacheWidth: memCacheWidth,
      memCacheHeight: memCacheHeight,
      maxWidthDiskCache: maxWidthDiskCache,
      maxHeightDiskCache: maxHeightDiskCache,
      placeholder: (_, __) => SkeletonLoading(
        width: width,
        height: height,
      ),
      errorWidget: (_, url, ___) {
        return errorWidget ?? _designSystem.mediaError();
      },
      imageBuilder:
          imgBuilder != null ? (_, image) => imgBuilder!.call(image) : null,
    );
  }
}
