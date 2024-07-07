import 'package:flutter/material.dart';

import '../../constants/locale.dart';

enum UniChatMessageType {
  /// Text message
  text,

  /// Image message
  image,

  /// Voice message
  voice,

  /// Video message
  video,

  /// Other include file type like pdf, doc, etc
  docFile;

  /// Returns `true` if the message type is [UniChatMessageType.text]
  bool get isTextMessage => this == UniChatMessageType.text;

  /// Returns `true` if the message type is [UniChatMessageType.image]
  bool get isImageMessage => this == UniChatMessageType.image;

  /// Returns `true` if the message type is [UniChatMessageType.voice]
  bool get isVoiceMessage => this == UniChatMessageType.voice;

  /// Returns `true` if the message type is [UniChatMessageType.video]
  bool get isVideoMessage => this == UniChatMessageType.video;

  /// Returns `true` if the message type is media message
  bool get isMediaMessage =>
      isImageMessage || isVideoMessage || isVoiceMessage || isDocFileMessage;

  /// Returns `true` if the message type is [UniChatMessageType.docFile]
  bool get isDocFileMessage => this == UniChatMessageType.docFile;
}

enum UniVoiceSpeedType {
  /// Normal speed
  normal(1.0),

  /// Fast speed
  fast(1.5),

  /// Slow speed
  slow(0.5);

  /// Speed of the voice note
  final double speed;
  const UniVoiceSpeedType(this.speed);
}

enum VoiceRecordStatus {
  recording,
  notRecording;

  /// Returns `true` if the status is [VoiceRecordStatus.recording]
  bool get isRecording => this == VoiceRecordStatus.recording;

  /// Returns `true` if the status is [VoiceRecordStatus.notRecording]
  bool get isNotRecording => this == VoiceRecordStatus.notRecording;
}

enum UniLoadingState {
  /// Loading state
  loading,

  /// Fetch state
  fetching,

  /// Sending
  sending,

  /// Not specified state
  notSpecified;

  /// Returns `true` if the state is [UniLoadingState.loading]
  bool get isLoading => this == UniLoadingState.loading;

  /// Returns `true` if the state is [UniLoadingState.fetching]
  bool get isFetching => this == UniLoadingState.fetching;

  /// Returns `true` if the state is [UniLoadingState.sending]
  bool get isSending => this == UniLoadingState.sending;

  /// Returns `true` if the state is [UniLoadingState.notSpecified]
  bool get isNotSpecified => this == UniLoadingState.notSpecified;
}

/// [UniChatLocale] is the locale type of the app
enum UniChatLocale {
  /// English locale
  en,

  /// Arabic locale
  ar;

  /// Returns `true` if the locale is [UniChatLocale.en]
  bool get isEnglish => this == UniChatLocale.en;

  /// Returns `true` if the locale is [UniChatLocale.ar]
  bool get isArabic => this == UniChatLocale.ar;

  /// [locale] Returns the locale based on the [UniChatLocale]
  Locale get locale => isArabic
      ? UniLocalizationsData.supportLocale.first
      : UniLocalizationsData.supportLocale.last;
}
