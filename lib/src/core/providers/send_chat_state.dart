// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uni_chat_sdk/src/core/extension/extenstion.dart';
import 'package:uni_chat_sdk/src/utils/navigation.dart';

import '../../../uni_chat_sdk.dart';
import '../../views/send_chat/media_view.dart';
import '../services/picker/picker_controller.dart';

/// Voice state-provider
final sendChatStateProvider =
    NotifierProvider<SendChatStateNotifier, SendChatState>(
        () => SendChatStateNotifier());

final _pickService = PickerServices.instance;

class SendChatStateNotifier extends Notifier<SendChatState> {
  @override
  SendChatState build() => SendChatState();

  // ---------------- Text ------------------------- //

  /// Message text controller
  TextEditingController messageTextController = TextEditingController();

  /// Media message text controller
  TextEditingController mediaMessageTextController = TextEditingController();

  // ---------------- Media ------------------------- //
  Future pickMedia(
    BuildContext context, {
    required UniChatMessageType type,
    required VoidSendMsg onSendChatMessage,
    ImageSource source = ImageSource.gallery,
  }) async {
    File? file;

    if (type.isImageMessage) {
      file = await _pickService.pickImage(source: source);
    } else if (type.isVideoMessage) {
      file = await _pickService.pickVideo();
    } else if (type.isDocFileMessage) {
      file = await _pickService.pickFile();
    }

    if (file != null) {
      state = state.copyWith(
        mediaAndVoiceFile: file,
        messageType: type,
      );
      context.pop();
      context.pushTo(SendMediaView(onSendChatMessage: onSendChatMessage));
    } else {
      context.pop();
    }
  }

  // ---------------- Voice Recording ------------------------- //

  /// Recorder controller
  RecorderController voiceController = RecorderController();

  /// Start recording voice
  Future startVoiceRecording() async {
    final isAllowedToRecord = await voiceController.checkPermission();
    if (isAllowedToRecord) {
      await voiceController.record();
      state = state.copyWith(
        mediaAndVoiceFile: null,
        recordStatus: VoiceRecordStatus.recording,
        messageType: UniChatMessageType.voice,
      );
    }
  }

  /// Stop recording voice
  Future<File?> stopVoiceRecording() async {
    final voicePath = await voiceController.stop();
    File? voiceFile;
    if (voicePath != null) {
      voiceFile = File(voicePath);
      state = state.copyWith(
        mediaAndVoiceFile: voiceFile,
        recordStatus: VoiceRecordStatus.notRecording,
      );
    }
    return voiceFile;
  }

  /// [sendChatMessage] Responsible to send the callback of sending the message
  Future sendChatMessage(
    BuildContext context, {
    required bool isFromMediaView,
    required VoidSendMsg onSendChatMessage,
  }) async {
    if (state.recordStatus.isRecording && state.messageType.isVoiceMessage) {
      final voiceFile = await stopVoiceRecording();
      if (voiceFile != null) {
        context.pushTo(SendMediaView(onSendChatMessage: onSendChatMessage));
      }
    } else {
      UniChatMessage message = UniChatMessage(
        message: messageTextController.textTrim,
        messageType: state.mediaAndVoiceFile == null
            ? UniChatMessageType.text
            : state.messageType,
        mediaText: mediaMessageTextController.textTrim,
        mediaFile: state.mediaAndVoiceFile,
        isSentByMe: true,
        sentBy: "1",
      );

      onSendChatMessage.call(message);
      if (isFromMediaView) context.pop();
    }
    return;
  }

  /// [clearSendChatState] is a method that clears the send chat state
  Future clearSendChatState({
    BuildContext? context,
  }) async {
    messageTextController.clear();
    mediaMessageTextController.clear();
    state = state.copyWith(
      mediaAndVoiceFile: null,
      recordStatus: VoiceRecordStatus.notRecording,
      messageType: UniChatMessageType.text,
    );
    context?.pop();
  }

  /// [rollBackSendState] is a method that rolls back the send state
  void rollBackSendState({
    required BuildContext context,
    required UniChatMessage message,
    required VoidSendMsg onSendChatMessage,
  }) {
    messageTextController.text = message.message;
    mediaMessageTextController.text = message.mediaText;
    state = state.copyWith(
      mediaAndVoiceFile: message.mediaFile,
      recordStatus: VoiceRecordStatus.notRecording,
      messageType: message.messageType,
    );
    if (message.messageType.isMediaMessage && message.mediaFile != null) {
      context.pushTo(SendMediaView(onSendChatMessage: onSendChatMessage));
    }
  }
}

class SendChatState {
  /// [mediaAndVoiceFile] is the file that contains the voice recording or any media file
  final File? mediaAndVoiceFile;

  /// [recordStatus] is the status of the voice recording
  final VoiceRecordStatus recordStatus;

  final UniChatMessageType messageType;

  /// [SendChatState] is the state where all the voice recording is managed
  SendChatState({
    this.mediaAndVoiceFile,
    this.recordStatus = VoiceRecordStatus.notRecording,
    this.messageType = UniChatMessageType.text,
  });

  /// Copy the voice state with new values
  SendChatState copyWith({
    File? mediaAndVoiceFile,
    VoiceRecordStatus? recordStatus,
    UniChatMessageType? messageType,
  }) {
    return SendChatState(
      mediaAndVoiceFile: mediaAndVoiceFile ?? mediaAndVoiceFile,
      recordStatus: recordStatus ?? this.recordStatus,
      messageType: messageType ?? this.messageType,
    );
  }
}

/// [VoidSendMsg] is a callback that sends the message
typedef VoidSendMsg = void Function(UniChatMessage message);
