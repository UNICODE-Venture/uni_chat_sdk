import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utils/navigation.dart';

class ServiceResponse<T> {
  late String errorMessage;
  late bool isSuccessFul;
  late String error;
  late T? response;

  ServiceResponse({
    this.errorMessage = "Something went wrong",
    this.isSuccessFul = false,
    this.error = "No error :)",
    this.response,
  });

  @override
  String toString() {
    return "isSuccessFul: $isSuccessFul,  errorMessage: $errorMessage, error: $error";
  }
}

/// [firebaseHandler] Call this method to to CRUD to Firebase Firestore database
Future<ServiceResponse> firebaseHandler<T>({required Future method}) async {
  ServiceResponse<T> serviceResponse = ServiceResponse<T>();
  try {
    serviceResponse.response = await method as T;
    serviceResponse.isSuccessFul = true;
  } on FirebaseException catch (e) {
    serviceResponse.errorMessage = e.message ?? "Something went wrong";
    serviceResponse.error = e.toString();
  } catch (e) {
    serviceResponse.errorMessage = "Something went wrong";
    serviceResponse.error = e.toString();
    printMeLog("Error: $e");
  }
  return serviceResponse;
}
