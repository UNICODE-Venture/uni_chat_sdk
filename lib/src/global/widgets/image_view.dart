import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import 'package:uni_chat_sdk/src/core/extension/extenstion.dart';

import '../../../generated/locale_keys.g.dart';
import '../uni_design.dart';
import 'cached_image.dart';

final _designSystem = UniDesignSystem.instance;

class UniFullImageView extends StatelessWidget {
  final File? imageFile;
  final String? imageUrl;

  const UniFullImageView({super.key, this.imageUrl, this.imageFile});

  @override
  Widget build(BuildContext context) {
    String tag = imageFile?.fileName ?? imageUrl ?? "";
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _designSystem.appBar(title: LocaleKeys.imgView.tr()),
      body: Hero(
        tag: tag,
        child: imageFile != null
            ? PhotoView(
                imageProvider: FileImage(imageFile!),
                minScale: .1,
                maxScale: .5,
              )
            : CachedImageView(
                url: imageUrl ?? "",
                imgBuilder: (img) => PhotoView(
                  imageProvider: img,
                  minScale: .1,
                  maxScale: .5,
                ),
              ),
      ),
    );
  }
}
