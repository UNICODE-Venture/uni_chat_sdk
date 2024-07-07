import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni_chat_sdk/src/core/extension/extenstion.dart';
import 'package:uni_chat_sdk/src/core/extension/size_extension.dart';
import 'package:uni_chat_sdk/src/core/providers/providers.dart';

import '../../../generated/locale_keys.g.dart';
import '../../core/providers/chat_state.dart';
import '../../core/providers/send_chat_state.dart';
import '../../core/providers/uni_chat_state.dart';
import '../../global/uni_design.dart';
import '../../global/widgets/animated_cross_fade.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import 'add_media_pop_over.dart';
import 'voice_record.dart';

final _textStyles = TextStyles.instance;
final _colors = ColorsPalletes.instance;
final _designSystem = UniDesignSystem.instance;

class UniSendChatInputView extends ConsumerStatefulWidget {
  final bool isFromMediaInput;
  final VoidSendMsg onSendChatMessage;

  /// [moreOptions] is the list of widgets that you want to show in the pop over
  final List<Widget>? moreOptions;
  const UniSendChatInputView({
    super.key,
    this.isFromMediaInput = false,
    required this.onSendChatMessage,
    this.moreOptions,
  });

  @override
  ConsumerState<UniSendChatInputView> createState() =>
      _UniSendChatInputViewState();
}

class _UniSendChatInputViewState extends ConsumerState<UniSendChatInputView> {
  @override
  Widget build(BuildContext context) {
    SendChatState sendChatState = ref.watch(sendChatStateProvider);
    UniChatState uniChatState = ref.watch(uniChatStateProvider);

    final sendChatStateNotifier = ref.sendChatStateNotifier;
    final isFromMediaInput = widget.isFromMediaInput;
    final textController = isFromMediaInput
        ? sendChatStateNotifier.mediaMessageTextController
        : sendChatStateNotifier.messageTextController;

    return Container(
      padding:
          isFromMediaInput ? EdgeInsets.symmetric(horizontal: 20.rw) : null,
      decoration: isFromMediaInput
          ? BoxDecoration(
              color: _colors.white,
              borderRadius: 10.br,
            )
          : null,
      child: Row(
        children: [
          AnimatedCrossFadeView(
            animationStatus: sendChatState.recordStatus.isRecording,
            shownIfTrue: CircleAvatar(
              radius: 20.rSp,
              backgroundColor: Colors.transparent,
              child: _designSystem.iconImage(
                icon: "trash",
                onTap: () async =>
                    await sendChatStateNotifier.stopVoiceRecording(),
              ),
            ),
            shownIfFalse: Visibility(
              visible: !isFromMediaInput && uniChatState.config.isHasMediaChat,
              child: CircleAvatar(
                radius: 20.rSp,
                backgroundColor: _colors.grey500,
                child: _designSystem.iconImage(
                  icon: "add",
                  size: 18.rSp,
                  onTap: () => showDialog(
                    context: context,
                    useRootNavigator: false,
                    builder: (_) => AddMediaPopOver(
                      onSendChatMessage: widget.onSendChatMessage,
                      moreOptions:
                          widget.moreOptions ?? uniChatState.config.moreOptions,
                    ),
                  ),
                ),
              ),
            ),
          ),
          16.hGap,
          Expanded(
            child: AnimatedCrossFadeView(
              animationStatus: sendChatState.recordStatus.isRecording,
              shownIfTrue: const VoiceRecordView(),
              shownIfFalse: TextField(
                minLines: 1,
                maxLines: 3,
                controller: textController,
                onChanged: (v) => setState(() {}),
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  hintText: LocaleKeys.writeChat.tr(),
                  border: InputBorder.none,
                  hintStyle: _textStyles.text14Medium,
                ),
              ),
            ),
          ),
          10.hGap,
          CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Consumer(
              builder: (_, ref, ___) {
                ///Check if the button is disabled
                bool isBtnDisabled = isFromMediaInput
                    ? false
                    : sendChatState.recordStatus.isNotRecording &&
                        textController.textTrim.isEmpty;

                return AnimatedCrossFadeView(
                  animationStatus:
                      ref.watch(chatStateProvider).loadingStatus.isSending,
                  shownIfTrue: _designSystem.loadingIndicator(),
                  shownIfFalse: AnimatedCrossFadeView(
                    animationStatus: (isFromMediaInput ||
                            !uniChatState.config.isHasVoiceNote)
                        ? true
                        : (textController.text.isNotEmpty ||
                            sendChatState.recordStatus.isRecording),
                    shownIfTrue: _designSystem.iconImage(
                      icon: "send",
                      isIconDisabled: isBtnDisabled,
                    ),
                    shownIfFalse: _designSystem.iconImage(icon: "mic"),
                    onPressed: () {
                      if (!isBtnDisabled) {
                        sendChatStateNotifier.sendChatMessage(
                          context,
                          onSendChatMessage: widget.onSendChatMessage,
                          isFromMediaView: isFromMediaInput,
                        );
                      } else if (sendChatState.recordStatus.isNotRecording &&
                          uniChatState.config.isHasVoiceNote) {
                        sendChatStateNotifier.startVoiceRecording();
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
