import 'package:flutter/material.dart';
import 'package:uni_chat_sdk/src/core/extension/size_extension.dart';
import 'package:uni_chat_sdk/src/utils/navigation.dart';

import '../../../global/uni_design.dart';
import '../../../theme/colors.dart';

final _designSystem = UniDesignSystem.instance;
final _colors = ColorsPalletes.instance;

class UniAddMediaBtn extends StatelessWidget {
  /// [text] is the text that is to be displayed on the button. [String]
  final String text;

  /// [icon] is the icon that is to be displayed on the button. [String]
  final String icon;

  /// [bgColor] is the background color of the button. [Color]
  final Color? bgColor;

  /// [onTap] is the function that is to be called when the button is tapped. [VoidCallback]
  final VoidCallback? onTap;

  const UniAddMediaBtn({
    super.key,
    required this.text,
    required this.icon,
    this.bgColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15.rSp),
      child: _designSystem.textIconRowBtn(
        icon: icon,
        text: text,
        color: bgColor ?? _colors.primaryColor,
        onTap: () {
          context.pop();
          onTap?.call();
        },
        isFromMoreBtn: true,
      ),
    );
  }
}
