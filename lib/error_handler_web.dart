import 'package:firebase_core/firebase_core.dart';

void handleFirebaseError(dynamic error) {
  if (error is FirebaseException) {
    print("FirebaseException: ${error.code} - ${error.message}");
  } else {
    print("Unknown error: $error");
  }
}
