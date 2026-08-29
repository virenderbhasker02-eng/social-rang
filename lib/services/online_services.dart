
/// Online service contracts used by the SocialStar UI.
///
/// Production implementations can use Firebase Auth, Firestore, Storage and FCM.
/// This scaffold intentionally contains no credentials and remains dependency-free.
abstract class AuthService {
  Future<String?> currentUserId();
  Future<void> signOut();
}

abstract class FeedService {
  Stream<List<Map<String, dynamic>>> watchFeed();
  Future<void> createPost(Map<String, dynamic> post);
  Future<void> react(String postId, String reaction);
  Future<void> comment(String postId, String text);
}

abstract class ChatService {
  Stream<List<Map<String, dynamic>>> watchMessages(String conversationId);
  Future<void> sendMessage(String conversationId, Map<String, dynamic> message);
}

abstract class NotificationService {
  Future<void> initialize();
  Future<void> markRead(String notificationId);
}

abstract class MediaService {
  Future<String> upload(String localPath, {required String destination});
}
