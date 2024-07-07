import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:uni_chat_sdk/src/core/extension/extenstion.dart';
import 'package:uni_chat_sdk/src/core/extension/size_extension.dart';

import '../../../generated/locale_keys.g.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';

final _colors = ColorsPalletes.instance;
final _textStyles = TextStyles.instance;

class UniToastAlert {
  UniToastAlert._();

  /// [showToastMessage] Is to show the toast message
  static showToastMessage({
    String? message,
    Color? bgColor,
    VoidCallback? onClose,
    Duration? duration,
    Alignment? align,
    bool isSuccess = true,
  }) {
    BotToast.showCustomNotification(
      duration: duration ?? 3.seconds,
      onClose: onClose,
      backButtonBehavior: BackButtonBehavior.close,
      align: align ?? Alignment.topCenter,
      useSafeArea: false,
      toastBuilder: (_) {
        return AnimatedContainer(
          duration: 300.milliseconds,
          height: 105.rh,
          width: 100.w,
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.only(bottom: 15.rh, right: 15.rw, left: 15.rw),
          color: bgColor ?? (isSuccess ? _colors.primaryColor : _colors.red),
          child: Text(
            message ??
                (isSuccess
                    ? LocaleKeys.successMsg.tr()
                    : LocaleKeys.tryAgain.tr()),
            textAlign: TextAlign.center,
            style: _textStyles.text15LightBoldWhite,
          ),
        );
      },
    );
  }
}
