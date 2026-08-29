# SocialStar v14 Online Deployment

## Required services
- Firebase Authentication
- Cloud Firestore
- Firebase Storage
- Firebase Cloud Messaging
- Server-side Cloud Functions/Cloud Run for privileged operations

## Setup
1. Create a Firebase project.
2. Enable authentication providers.
3. Create Firestore and Storage.
4. Run `flutterfire configure`.
5. Add generated `firebase_options.dart`.
6. Add Firebase Flutter packages to `pubspec.yaml`.
7. Implement the service contracts in `lib/services/online_services.dart`.
8. Deploy reviewed Firestore/Storage rules.
9. Add App Check and server-side rate limits.
10. Configure FCM for Android/iOS.

No credentials are included in this build.
