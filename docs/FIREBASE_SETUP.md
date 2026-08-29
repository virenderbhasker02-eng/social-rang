# Firebase setup for SocialStar v7

1. Install Flutter and Firebase CLI.
2. Create a Firebase project.
3. Enable Authentication providers (Phone and/or Email/Password).
4. Create Firestore Database.
5. Enable Storage.
6. Configure Cloud Messaging for push notifications.
7. In the project directory run:
   `flutterfire configure`
8. Keep generated `lib/firebase_options.dart` private and out of public source control.
9. Replace the example rules with reviewed production rules.
10. Add server-side Cloud Functions for notifications, moderation and monetization ledger events.

The current ZIP intentionally contains no real Firebase credentials.
