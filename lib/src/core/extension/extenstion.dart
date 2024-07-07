import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import "package:timeago/timeago.dart" as time_ago;
import 'package:uni_chat_sdk/src/utils/navigation.dart';

import '../../constants/locale.dart';
import '../../utils/utils.dart';

final _utils = UniUtils.instance;

/// Extension for [String]
extension TextExt on String {
  /// Return the int value of the string
  int get toInt => int.tryParse(this) ?? 0;

  /// Return the num value of the string
  num get toNum => num.tryParse(this) ?? 0;

  /// Is Values are the same
  bool isEqualTo(String? val) => this == val;

  /// Is Values are not the same
  bool isNotEqualTo(String? val) => this != val;

  /// [fileNameFromFirebaseStorageUrl] Return the file name from the firebase storage url
  String get fileNameFromFirebaseStorageUrl {
    RegExp regExp = RegExp(r'.+(\/|%2F)(.+)\?.+');
    var matches = regExp.allMatches(this);
    var match = matches.elementAt(0);
    return Uri.decodeFull(match.group(2)!);
  }

  /// [fileNameFromRegulerUrl] Return the file name from the url
  String get fileNameFromRegulerUrl => split('/').last;

  /// [fileNameFromUrl] Return the file name from the url
  String get fileNameFromUrl {
    String fileName = "";
    // Firebase
    if (contains("firebasestorage")) {
      fileName = fileNameFromFirebaseStorageUrl;
    }
    // Regular
    else {
      fileName = fileNameFromRegulerUrl;
    }

    // If the file name longer than 10 characters, then return the first 10 characters with extension
    if (fileName.length > 15) {
      fileName = "${fileName.substring(0, 15)}.${fileName.split('.').last}";
    }

    return fileName;
  }
}

/// Extension for [num]
extension UniNumExtension on num {
  ///* Return [BorderRadius] for widget
  BorderRadius get br => BorderRadius.circular(toDouble());

  ///* Padding `EdgeInsets.all(this)`
  EdgeInsets get paddingAll => EdgeInsets.all(toDouble());

  ///* Padding `EdgeInsets.all(this)`
  EdgeInsets get paddingTop => EdgeInsets.only(top: toDouble());

  ///* Return [Radius] for widget
  Radius get rBr => Radius.circular(toDouble());

  ///* Substract date
  DateTime get pDate => DateTime.now().subtract(Duration(days: toInt()));

  ///* Substract date
  DateTime get fDate => DateTime.now().add(Duration(days: toInt()));

  Duration get seconds => Duration(seconds: toInt());
  Duration get milliseconds => Duration(milliseconds: toInt());

  ///* Get uid from specific digit `5.uuid`
  String get uuid => _utils.getUID.substring(0, toInt());

  /// [isValidIndex] Check if the index is valid
  bool get isValidIndex => !isNegative && !isNaN;
}

extension IterableExtension<T> on Iterable<T> {
  /// Remove the duplicates items from the list
  List<T> removeDuplicates<U>({required U Function(T t) by}) {
    final unique = <U, T>{};

    for (final item in this) {
      unique.putIfAbsent(by(item), () => item);
    }

    return unique.values.toList();
  }

  /// Get the item matched with conditions or return null value
  T? findOrNull(bool Function(T item) by) {
    try {
      return firstWhere((i) => by(i));
    } catch (e) {
      return null;
    }
  }
}

/// Extension for [num] to make space using `SizedBox`
extension SpaceExt on num {
  /// Return `SizedBox` with width
  SizedBox get hGap => SizedBox(width: toDouble());

  /// Return `SizedBox` with height
  SizedBox get vGap => SizedBox(height: toDouble());
}

/// Extension for [Duration]
extension DurationExt on Duration {
  ///* Format voice timer [01:30]
  String get formatVoiceNoteDuration {
    final totalSeconds = inSeconds;
    final duration = Duration(seconds: totalSeconds);
    final minutes = duration.inMinutes;
    final seconds = totalSeconds % 60;

    final minutesString = '$minutes'.padLeft(2, '0');
    final secondsString = '$seconds'.padLeft(2, '0');
    return '$minutesString:$secondsString';
  }
}

/// Extension for [File]
extension FileExt on File {
  /// [fileName] Return the file name from the path
  String get fileName => path.split('/').last;

  /// [genUniqueFileName] Generate file name based on file, e.g: `1a4d5_logo.png`
  String get genUniqueFileName {
    String fileName = "${5.uuid}_${this.fileName}";
    return fileName;
  }
}

/// Extension for [DateTime]
extension DateTimeExt on DateTime {
  /// [today] Return the current date time
  static final DateTime today = DateTime.now();

  /// [timeAgo] Return the time ago from the current time [1 minute ago]
  String get timeAgo => time_ago.format(this,
      locale: UniLocalizationsData.currentLocale.languageCode);

  /// Return Formatted Day, Month, Year name as `String` [19 July 2022]
  String get dateDayMonthYearFormat =>
      DateFormat.yMMMd(UniLocalizationsData.currentLocale.languageCode)
          .format(this);

  /// Return ```true``` if provided date is today
  bool get isToday =>
      today.day == day && today.month == month && today.year == year;

  /// Return ```true``` if provided date is yesterday
  bool get isYesterday {
    final yesterday = today.subtract(const Duration(days: 1));
    return yesterday.day == day &&
        yesterday.month == month &&
        yesterday.year == year;
  }

  /// Return Formatted Day, Month, Year name as `String` [12:00 PM, 19 July 2022]
  String get fullDateTimeFormat =>
      DateFormat(null, UniLocalizationsData.currentLocale.languageCode)
          .add_MMMEd()
          .add_jm()
          .format(this);
}

/// Extension for [Locale]
extension LocaleExt on Locale {
  /// [isArabic] Return true if the language is Arabic
  bool get isArabic => languageCode
      .isEqualTo(UniLocalizationsData.supportLocale.first.languageCode);

  /// [isEnglish] Return true if the language is English
  bool get isEnglish => languageCode
      .isEqualTo(UniLocalizationsData.supportLocale.last.languageCode);
}

extension StreamSubscriptionExt on StreamSubscription? {
  /// [update] is a method to update the stream subscription
  void update(bool isResume) {
    if (this != null) {
      if (isResume && this!.isPaused) {
        this?.resume();
        printMe("Stream resumed: $runtimeType");
      } else if (!isResume) {
        this?.pause();
        printMe("Stream paused: $runtimeType");
      }
    }
  }
}

/// Extension for [TextEditingController]
extension TextEditingExt on TextEditingController {
  /// [textTrim] Return the trimmed text from the controller
  String get textTrim => text.trim();
}
