import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:uni_chat_sdk/src/core/extension/extenstion.dart';

import 'package:uni_chat_sdk/src/core/extension/size_extension.dart';

import '../constants/assets_paths.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import 'widgets/glass_morphism.dart';

final _colors = ColorsPalletes.instance;
final _textStyles = TextStyles.instance;

class UniDesignSystem {
  UniDesignSystem._();
  static UniDesignSystem? _instance;

  /// Get the instance of the [UniDesignSystem]
  static UniDesignSystem get instance => _instance ??= UniDesignSystem._();

  /// App bar of the screen
  AppBar appBar({
    required String title,
  }) {
    return AppBar(
      leading: BackButton(color: _colors.black),
      backgroundColor: _colors.white.withAlpha(100),
      title: Text(title,
          style: _textStyles.text16Bold.copyWith(color: _colors.black)),
      centerTitle: true,
      flexibleSpace: GlassMorphism(
        child: Container(color: Colors.transparent),
      ),
    );
  }

  /// Media error widget
  Widget mediaError() => Icon(
        Icons.image_not_supported_outlined,
        color: _colors.red,
      );

  /// Default duration
  Duration get kDefaultDuration => const Duration(milliseconds: 300);

  /// `Transform` widget for non-rtl widget
  Widget transformLocalizedWidget(
      {required Widget child, bool isViceVersa = false}) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(isViceVersa ? 0 : pi),
      child: child,
    );
  }

  /// Icon image widget
  Widget iconImage({
    required String icon,
    double? size,
    Color? color,
    Function()? onTap,
    bool isIconDisabled = false,
    bool isFromMoreBtn = false,
  }) =>
      InkWell(
        onTap: onTap,
        child: Image.asset(
          "${UniAssetsPath.icons}/$icon.png",
          height: size ?? 24.rSp,
          width: size ?? 24.rSp,
          package: isFromMoreBtn ? null : UniAssetsPath.packageName,
          color: isIconDisabled ? _colors.grey20 : color,
        ),
      );

  /// Player duration widget
  Widget playerDurationWidget({
    required int duration,
    Color? color,
  }) =>
      Text(
        duration.milliseconds.formatVoiceNoteDuration,
        style: _textStyles.text14Medium.copyWith(
          color: color ?? _colors.black,
        ),
      );

  /// Text Icon Button
  Widget textIconRowBtn({
    required String text,
    required String icon,
    Color? color,
    Function()? onTap,
    bool isFromMoreBtn = false,
  }) =>
      InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 25.rSp,
              backgroundColor: color,
              child: iconImage(
                icon: icon,
                color: _colors.white,
                size: 20.rSp,
                isFromMoreBtn: isFromMoreBtn,
              ),
            ),
            16.hGap,
            Text(
              text,
              style: _textStyles.text14MediumWhite,
            ),
          ],
        ),
      );

  /// [backDropBlur] Backdrop blur widget
  Widget backDropBlur({
    required Widget child,
  }) =>
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.rSp, sigmaY: 5.rSp),
        child: child,
      );

  /// [loadingIndicator] Loading indicator
  Widget loadingIndicator() => const Center(
        child: CircularProgressIndicator.adaptive(),
      );

  /// Time label text
  Widget timeText(String time) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.rh),
      // padding: EdgeInsets.symmetric(vertical: 7.rh, horizontal: 20.rw),
      // decoration: BoxDecoration(
      //     color: _colors.primaryColor.withOpacity(.5), borderRadius: 10.br),
      child: Text(
        time,
        textAlign: TextAlign.center,
        style: _textStyles.text14Medium,
      ),
    );
  }
}
