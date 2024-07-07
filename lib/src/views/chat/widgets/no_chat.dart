import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:uni_chat_sdk/src/core/extension/extenstion.dart';
import 'package:uni_chat_sdk/src/core/extension/size_extension.dart';

import '../../../../generated/locale_keys.g.dart';
import '../../../constants/assets_paths.dart';
import '../../../theme/text_styles.dart';

final _textStyles = TextStyles.instance;

class NoChatFoundView extends StatelessWidget {
  const NoChatFoundView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Image.asset(
            "${UniAssetsPath.images}/chat.png",
            height: 30.h,
            package: UniAssetsPath.packageName,
          ),
        ),
        30.vGap,
        Text(
          LocaleKeys.noChat.tr(),
          style: _textStyles.text16Bold,
        )
      ],
    );
  }
}
