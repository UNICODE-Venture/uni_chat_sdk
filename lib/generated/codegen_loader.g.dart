// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes, avoid_renaming_method_parameters

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> en = {
  "chatRooms": "Chat rooms",
  "file": "Add File",
  "fileShared": "File shared 📄",
  "image": "Add Image",
  "imageCam": "Capture an image",
  "imageShared": "Image shared 📷",
  "imgView": "Image view",
  "noChat": "With a laugh and a joke, it's a chat we’ll enjoy!",
  "successMsg": "Your request has been successfully completed.",
  "today": "Today",
  "tryAgain": "Something went wrong, kindly try again.",
  "video": "Add video",
  "videoShared": "Video shared 🎥",
  "voiceShared": "Voice message shared 🎤",
  "writeChat": "Write your message here...",
  "yesterday": "Yesterday"
};
static const Map<String,dynamic> ar = {
  "chatRooms": "غرف الدردشة",
  "file": "إضافة ملف",
  "fileShared": "تمت مشاركة الملف 📄",
  "image": "إضافة صورة",
  "imageCam": "التقاط الصورة",
  "imageShared": "تمت مشاركة الصورة 📷",
  "imgView": "عرض الصورة",
  "noChat": "بضحكة ونكتة، ستكون دردشة ممتعة!",
  "successMsg": "لقد تم إكمال طلبك بنجاح.",
  "today": "اليوم",
  "tryAgain": "حدث خطأ ما، يرجى المحاولة مرة أخرى.",
  "video": "إضافة فيديو",
  "videoShared": "تمت مشاركة الفيديو 🎥",
  "voiceShared": "تمت مشاركة الرسالة الصوتية 🎤",
  "writeChat": "اكتب رسالتك هنا...",
  "yesterday": "أمس"
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en": en, "ar": ar};
}
