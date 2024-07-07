import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uni_chat_sdk/src/core/extension/extenstion.dart';
import 'package:uni_chat_sdk/src/core/extension/size_extension.dart';
import 'package:uni_chat_sdk/src/core/providers/providers.dart';
import 'package:uni_chat_sdk/src/utils/navigation.dart';

import '../../../generated/locale_keys.g.dart';
import '../../../uni_chat_sdk.dart';
import '../../core/providers/send_chat_state.dart';
import '../../core/providers/uni_chat_state.dart';
import '../../global/uni_design.dart';
import '../../theme/colors.dart';

final _colors = ColorsPalletes.instance;
final _designSystem = UniDesignSystem.instance;

class AddMediaPopOver extends ConsumerWidget {
  final VoidSendMsg onSendChatMessage;

  /// [moreOptions] is the list of widgets that you want to show in the pop over
  final List<Widget> moreOptions;
  const AddMediaPopOver({
    super.key,
    required this.onSendChatMessage,
    this.moreOptions = const [],
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sendStateNotifier = ref.sendChatStateNotifier;
    final uniChatState = ref.read(uniChatStateProvider);
    UniChatConfig config = uniChatState.config;
    return _designSystem.backDropBlur(
        child: GestureDetector(
      onTap: () => context.pop(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.rSp),
          width: 100.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (config.isHasImage) ...[
                // Image
                _designSystem.textIconRowBtn(
                  icon: "image",
                  text: LocaleKeys.image.tr(),
                  color: _colors.blueSky,
                  onTap: () async => await sendStateNotifier.pickMedia(context,
                      type: UniChatMessageType.image,
                      onSendChatMessage: onSendChatMessage),
                ),
                // Image from camera
                15.vGap,
                _designSystem.textIconRowBtn(
                  icon: "camera",
                  text: LocaleKeys.imageCam.tr(),
                  color: _colors.pink,
                  onTap: () async => await sendStateNotifier.pickMedia(
                    context,
                    type: UniChatMessageType.image,
                    onSendChatMessage: onSendChatMessage,
                    source: ImageSource.camera,
                  ),
                )
              ],

              // Video
              if (config.isHasVideo) ...[
                15.vGap,
                _designSystem.textIconRowBtn(
                  icon: "video",
                  text: LocaleKeys.video.tr(),
                  color: _colors.greenLight,
                  onTap: () async => await sendStateNotifier.pickMedia(context,
                      type: UniChatMessageType.video,
                      onSendChatMessage: onSendChatMessage),
                ),
              ],

              // Attachment
              if (config.isHasDocFile) ...[
                15.vGap,
                _designSystem.textIconRowBtn(
                  icon: "attachment",
                  text: LocaleKeys.file.tr(),
                  color: _colors.deepOrange,
                  onTap: () async => await sendStateNotifier.pickMedia(
                    context,
                    type: UniChatMessageType.docFile,
                    onSendChatMessage: onSendChatMessage,
                  ),
                ),
              ],
              ...moreOptions,
              30.vGap,
              Material(
                borderRadius: 30.br,
                clipBehavior: Clip.antiAlias,
                color: _colors.white.withOpacity(.12),
                child: InkWell(
                  onTap: () => context.pop(),
                  child: CircleAvatar(
                    radius: 25.rSp,
                    backgroundColor: Colors.transparent,
                    child: Icon(
                      Icons.close_rounded,
                      size: 22.rSp,
                      color: _colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
