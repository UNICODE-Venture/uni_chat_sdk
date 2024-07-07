import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uni_chat_sdk/src/core/extension/extenstion.dart';

import '../../../utils/navigation.dart';
import '../../repo/collections.dart';

FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

class StorageServices {
  StorageServices._();
  static StorageServices? _instance;
  static StorageServices get instance => _instance ??= StorageServices._();

  ///* Upload [Chat] related images
  Future<StorageResponse> uploadChatContent({
    required String roomId,
    required File file,
  }) async {
    return await _uploadFile(
        reference: StorageRef.getChatMediaRef(file, roomId), file: file);
  }

  ///* Upload Files
  Future<StorageResponse> _uploadFile(
      {required Reference reference, required File file}) async {
    StorageResponse response = StorageResponse();
    try {
      TaskSnapshot task = await reference.putFile(file);
      String url = await task.ref.getDownloadURL();
      response.downloadUrl = url;
      response.isSuccess = true;
    } catch (e) {
      response.error = e.toString();
    }
    return response;
  }

  ///* Upload Files with [TASK SNAPSHOT]
  UploadTask uploadTask({required Reference reference, required File file}) {
    UploadTask task = reference.putFile(file);
    return task;
  }

  ///* Delete files from cloud-storage
  Future<bool> deleteFiles(String url) async {
    try {
      if (url.isNotEmpty) await _firebaseStorage.refFromURL(url).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  ///* Delete bulk files from cloud-storage
  Future deleteBulkFiles({required List<String> urls}) async {
    for (String url in urls) {
      try {
        if (url.isNotEmpty) await _firebaseStorage.refFromURL(url).delete();
      } catch (e) {
        printMe("deleteBulkFiles-------->$e");
      }
    }
    return true;
  }
}

class StorageRef {
  StorageRef._();

  /// Generate reference for [ChatMedia] files
  static Reference getChatMediaRef(File file, String roomId) => _firebaseStorage
      .ref()
      .child(Collections.chatMessages)
      .child(roomId)
      .child(file.genUniqueFileName);
}

class StorageResponse {
  late String downloadUrl;
  late bool isSuccess;
  late String error;

  StorageResponse({
    this.downloadUrl = "",
    this.isSuccess = false,
    this.error = "",
  });
}
