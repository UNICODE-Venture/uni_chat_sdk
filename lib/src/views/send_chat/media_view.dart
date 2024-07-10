import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni_chat_sdk/src/core/extension/extenstion.dart';
import 'package:uni_chat_sdk/src/core/extension/size_extension.dart';
import 'package:uni_chat_sdk/src/core/providers/providers.dart';

import 'package:video_player/video_player.dart';

import '../../core/enums/enums.dart';
import '../../core/providers/send_chat_state.dart';
import '../../global/uni_design.dart';
import '../../global/widgets/skeleton_loading.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../chat/bubbles/voice_note_bubble.dart';
import 'send_chat_input.dart';

final _colors = ColorsPalletes.instance;
final _designSystem = UniDesignSystem.instance;
final _textStyles = TextStyles.instance;

class SendMediaView extends ConsumerStatefulWidget {
  final VoidSendMsg onSendChatMessage;
  const SendMediaView({super.key, required this.onSendChatMessage});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SendMediaViewState();
}

class _SendMediaViewState extends ConsumerState<SendMediaView> {
  @override
  Widget build(BuildContext context) {
    final sendChatState = ref.watch(sendChatStateProvider);
    final sendChatStateNotifier = ref.sendChatStateNotifier;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: _colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: InkWell(
          onTap: () =>
              sendChatStateNotifier.clearSendChatState(context: context),
          child: Container(
            width: 25.rSp,
            height: 25.rSp,
            margin: EdgeInsets.symmetric(horizontal: 10.rSp),
            decoration: BoxDecoration(
                color: _colors.white.withOpacity(.2), shape: BoxShape.circle),
            child:
                Icon(Icons.close_rounded, size: 23.rSp, color: _colors.white),
          ),
        ),
        actions: [
          _designSystem.iconImage(
            icon: "trash",
            color: Colors.white,
            onTap: () =>
                sendChatStateNotifier.clearSendChatState(context: context),
          ),
          15.hGap,
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          // Display the image or video file
          if (sendChatState.mediaAndVoiceFile != null)
            Positioned.fill(
              child: _showWidgetByMsgType(sendChatState),
            ),
          Positioned(
            bottom: 7.h,
            width: 90.w,
            height: 60.rh,
            child: UniSendChatInputView(
              isFromMediaInput: true,
              onSendChatMessage: widget.onSendChatMessage,
            ),
          ),
        ],
      ),
    );
  }

  /// Widget shows based on the type
  Widget _showWidgetByMsgType(SendChatState state) {
    UniChatMessageType type = state.messageType;
    return switch (type) {
      UniChatMessageType.image => Image.file(
          state.mediaAndVoiceFile!,
          fit: BoxFit.cover,
        ),
      UniChatMessageType.video =>
        VideoMedia(videoFile: state.mediaAndVoiceFile!),
      UniChatMessageType.docFile => Container(
          width: 100.w,
          padding: EdgeInsets.all(20.rSp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _designSystem.iconImage(
                icon: "attachment",
                size: 30.rSp,
              ),
              16.hGap,
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 70.w),
                child: Text(
                  state.mediaAndVoiceFile!.fileName,
                  style: _textStyles.text20MediumWhite,
                  maxLines: 5,
                ),
              ),
            ],
          ),
        ),
      UniChatMessageType.text => const SizedBox.shrink(),
      UniChatMessageType.voice => Align(
          child: Container(
            padding: 5.paddingAll,
            decoration: BoxDecoration(
              color: _colors.primaryColor,
              borderRadius: 13.br,
            ),
            child: VoicePlayerBubble(
              voiceFile: state.mediaAndVoiceFile!,
              isSentByMe: true,
              isWhiteContent: true,
            ),
          ),
        ),
    };
  }
}

class VideoMedia extends StatefulWidget {
  final File videoFile;
  const VideoMedia({super.key, required this.videoFile});

  @override
  State<VideoMedia> createState() => _VideoMediaState();
}

class _VideoMediaState extends State<VideoMedia> {
  VideoPlayerController? _videController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();

    // Initialize the video controller and display the video when the widget is created
    _initVideo();
  }

  @override
  void dispose() {
    _videController?.dispose();
    super.dispose();
  }

  Future _initVideo() async {
    _videController = VideoPlayerController.file(widget.videoFile);
    await _videController?.initialize();
    if (_videController != null) {
      _chewieController = ChewieController(
        videoPlayerController: _videController!,
        autoInitialize: true,
        allowFullScreen: false,
        hideControlsTimer: 1.seconds,
        controlsSafeAreaMinimum: EdgeInsets.only(bottom: 13.h),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _colors.black,
      height: 50.h,
      child: _chewieController != null
          ? SafeArea(
              child: AspectRatio(
                aspectRatio: _videController!.value.aspectRatio,
                child: Chewie(controller: _chewieController!),
              ),
            )
          : SkeletonLoading(
              width: 100.w,
              height: 100.h,
            ),
    );
  }
}
