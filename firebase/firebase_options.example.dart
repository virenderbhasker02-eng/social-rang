// Copy to lib/firebase_options.dart after configuring FlutterFire.
// Do not commit real Firebase credentials to public repositories.
import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform => throw UnimplementedError(
    'Run: flutterfire configure, then replace this file with generated firebase_options.dart',
  );
}
