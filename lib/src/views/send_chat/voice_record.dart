import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni_chat_sdk/src/core/extension/extenstion.dart';
import 'package:uni_chat_sdk/src/core/extension/size_extension.dart';
import 'package:uni_chat_sdk/src/core/providers/providers.dart';

import '../../global/uni_design.dart';
import '../../theme/colors.dart';

final _colors = ColorsPalletes.instance;
final _designSystem = UniDesignSystem.instance;

class VoiceRecordView extends ConsumerStatefulWidget {
  const VoiceRecordView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VoiceRecordViewState();
}

class _VoiceRecordViewState extends ConsumerState<VoiceRecordView> {
  @override
  Widget build(BuildContext context) {
    final voiceStateNotifier = ref.sendChatStateNotifier;

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AudioWaveforms(
          size: Size(50.w, 40.rSp),
          recorderController: voiceStateNotifier.voiceController,
          waveStyle: WaveStyle(
            waveThickness: 3.rSp,
            scaleFactor: 35.rSp,
            waveColor: _colors.grey400,
            showMiddleLine: false,
            extendWaveform: true,
          ),
        ),
        10.hGap,
        // Player duration
        _playerDurationWidget(voiceStateNotifier.voiceController),
      ],
    );
  }

  /// Player duration widget
  Widget _playerDurationWidget(RecorderController controller) => StreamBuilder(
        stream: controller.onCurrentDuration,
        builder: (_, AsyncSnapshot<Duration> snapshot) {
          return _designSystem.playerDurationWidget(
              duration: snapshot.data?.inMilliseconds ?? 0);
        },
      );
}
