import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/navigation.dart';

final _picker = ImagePicker();
final _filePicker = FilePicker.platform;

class PickerServices {
  PickerServices._();
  static PickerServices? _instance;

  /// Singleton instance of [PickerServices]
  static PickerServices get instance => _instance ??= PickerServices._();

  /// Pick Image from Gallery or Camera
  Future<File?> pickImage({ImageSource source = ImageSource.gallery}) async {
    final image = await _picker.pickImage(source: source);
    return image != null ? File(image.path) : null;
  }

  /// Pick Video from File or Gallery
  Future<File?> pickVideo() async {
    try {
      final fileResult = await _filePicker.pickFiles(type: FileType.video);
      if (fileResult != null && fileResult.files.isNotEmpty) {
        final file = File(fileResult.files.single.path!);
        return file;
      }
    } catch (e) {
      printMeLog("Error in pickVideo: $e");
    }
    return null;
  }

  /// Pick File from File support only pdf, and doc
  Future<File?> pickFile() async {
    try {
      final fileResult = await _filePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc'],
      );
      if (fileResult != null && fileResult.files.isNotEmpty) {
        final file = File(fileResult.files.single.path!);
        return file;
      }
    } catch (e) {
      printMeLog("Error in pickFile: $e");
    }
    return null;
  }
}
