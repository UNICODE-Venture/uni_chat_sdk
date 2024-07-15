import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';

import 'package:uni_chat_sdk/src/core/extension/extenstion.dart';
import 'package:uni_chat_sdk/src/core/extension/size_extension.dart';

import '../../../../uni_chat_sdk.dart';
import '../../../constants/assets_paths.dart';
import '../../../core/services/storage/cache_services.dart';
import '../../../global/uni_design.dart';
import '../../../global/widgets/skeleton_loading.dart';
import '../../../theme/colors.dart';
import '../widgets/chat_loading.dart';

final _colors = ColorsPalletes.instance;
final _designSystem = UniDesignSystem.instance;

class VoiceNoteBubble extends StatefulWidget {
  /// [uniChatMessage] is the message that is to be displayed
  final UniChatMessage uniChatMessage;

  /// [contentColor] is the color of the content inside the bubble. If not provided, it will be the default color based on the message type
  final Color? contentColor;

  /// [VoiceNoteBubble] is the widget that displays the text message
  const VoiceNoteBubble(
      {super.key, required this.uniChatMessage, this.contentColor});

  @override
  State<VoiceNoteBubble> createState() => _VoiceNoteBubbleState();
}

class _VoiceNoteBubbleState extends State<VoiceNoteBubble> {
  final _cacheServices = CacheServices.instance;
  File? voiceFile;
  @override
  void initState() {
    super.initState();
    _initVoiceNote();
  }

  Future _initVoiceNote() async {
    voiceFile = widget.uniChatMessage.mediaFile ??
        await _cacheServices.getFile(widget.uniChatMessage.message);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final uniChatMessage = widget.uniChatMessage;
    return voiceFile != null
        ? VoicePlayerBubble(
            contentColor: widget.contentColor,
            isSentByMe: uniChatMessage.isSentByMe,
            voiceFile: voiceFile!,
          )
        : PeerWidget(
            isSentByMe: uniChatMessage.isSentByMe,
            child: Center(child: SkeletonLoading(width: 80.w, height: 50.rh)));
  }
}

class VoicePlayerBubble extends StatefulWidget {
  final File voiceFile;
  final bool isSentByMe;
  final bool isWhiteContent;

  /// [contentColor] is the color of the content inside the bubble. If not provided, it will be the default color based on the message type
  final Color? contentColor;
  const VoicePlayerBubble({
    super.key,
    required this.voiceFile,
    required this.isSentByMe,
    this.isWhiteContent = false,
    this.contentColor,
  });

  @override
  State<VoicePlayerBubble> createState() => _VoicePlayerBubbleState();
}

class _VoicePlayerBubbleState extends State<VoicePlayerBubble> {
  final _voiceNotePlayerController = PlayerController();
  ValueNotifier<bool> voiceNoteFileReady = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _initVoiceNote();
  }

  Future _initVoiceNote() async {
    await _voiceNotePlayerController.preparePlayer(
        path: widget.voiceFile.path, noOfSamples: 200);
    voiceNoteFileReady.value = true;
  }

  @override
  void dispose() {
    _voiceNotePlayerController.pausePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isSentByMe = widget.isSentByMe;
    Color contentColor = widget.contentColor ??
        (widget.isWhiteContent
            ? _colors.white
            : isSentByMe
                ? _colors.black
                : _colors.white);
    return ValueListenableBuilder(
        valueListenable: voiceNoteFileReady,
        builder: (context, bool isVoiceNoteFileReady, __) {
          return StreamBuilder(
              stream: _voiceNotePlayerController.onPlayerStateChanged,
              builder: (_, AsyncSnapshot<PlayerState> snapshot) {
                PlayerState playerState = snapshot.data ?? PlayerState.stopped;
                bool isVoiceNotePlaying = playerState == PlayerState.playing;
                bool readyToPlay = _voiceNotePlayerController.maxDuration != -1;

                return Container(
                  height: 56.rh,
                  width: 80.w,
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.rSp, vertical: 7.rSp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Voice note controller
                      Visibility(
                        visible: isSentByMe,
                        replacement: _playerDurationWidget(
                            isVoiceNotePlaying, contentColor),
                        child: _controllerWidgets(
                            isVoiceNotePlaying, contentColor),
                      ),
                      10.hGap,
                      // Voice note waveform
                      if (readyToPlay && isVoiceNoteFileReady)
                        Expanded(
                          child: _designSystem.transformLocalizedWidget(
                            isViceVersa: isSentByMe,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return AudioFileWaveforms(
                                  waveformType: WaveformType.long,
                                  enableSeekGesture: true,
                                  size: Size(constraints.maxWidth - 10,
                                      constraints.maxHeight),
                                  playerController: _voiceNotePlayerController,
                                  playerWaveStyle: PlayerWaveStyle(
                                    liveWaveColor: contentColor,
                                    fixedWaveColor: contentColor,
                                    waveThickness: 3.rSp,
                                    scaleFactor: 45.rSp,
                                    seekLineColor: contentColor,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      10.hGap,
                      // Voice note duration
                      Visibility(
                        visible: isSentByMe,
                        replacement: _controllerWidgets(
                            isVoiceNotePlaying, contentColor),
                        child: _playerDurationWidget(
                            isVoiceNotePlaying, contentColor),
                      ),
                    ],
                  ),
                );
              });
        });
  }

  /// Player control widget
  Widget _controllerWidgets(bool isVoiceNotePlaying, Color color) =>
      _designSystem.transformLocalizedWidget(
        child: InkWell(
          onTap: () async {
            if (_voiceNotePlayerController.playerState == PlayerState.playing) {
              await _voiceNotePlayerController.pausePlayer();
            } else {
              await _voiceNotePlayerController.startPlayer(
                  finishMode: FinishMode.pause);
            }
          },
          child: AnimatedCrossFade(
            firstChild: _voiceNoteControlWidget("ic_play", color),
            secondChild: _voiceNoteControlWidget("ic_pause", color),
            crossFadeState: isVoiceNotePlaying
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: _designSystem.kDefaultDuration,
            firstCurve: Curves.fastOutSlowIn,
            secondCurve: Curves.easeInOut,
          ),
        ),
      );

  /// Player control widget
  Widget _voiceNoteControlWidget(String icon, Color color) {
    return Image.asset(
      "${UniAssetsPath.icons}/$icon.png",
      height: 30.rSp,
      width: 30.rSp,
      color: color,
      package: UniAssetsPath.packageName,
    );
  }

  /// Player duration widget
  Widget _playerDurationWidget(bool isVoiceNotePlaying, Color color) =>
      StreamBuilder(
        stream: _voiceNotePlayerController.onCurrentDurationChanged,
        builder: (_, AsyncSnapshot<int> snapshot) {
          int currentDuration = isVoiceNotePlaying
              ? snapshot.data ?? 0
              : _voiceNotePlayerController.maxDuration;

          return _designSystem.playerDurationWidget(
              duration: currentDuration, color: color);
        },
      );
}
