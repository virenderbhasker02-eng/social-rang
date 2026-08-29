import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Single online data layer for SocialStar.
/// UI must call this repository rather than local/demo stores.
class SocialStarRepository {
  SocialStarRepository({FirebaseFirestore? db, FirebaseAuth? auth})
      : db = db ?? FirebaseFirestore.instance,
        auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore db;
  final FirebaseAuth auth;

  String get uid => auth.currentUser?.uid ?? (throw StateError('Sign in first'));

  Future<void> upsertUser(Map<String, dynamic> data) async {
    await db.collection('users').doc(uid).set({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> user() =>
      db.collection('users').doc(uid).snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> feed() => db
      .collection('posts')
      .orderBy('createdAt', descending: true)
      .limit(50)
      .snapshots();

  Future<DocumentReference<Map<String, dynamic>>> createPost({
    required String text,
    String? mediaUrl,
    String type = 'text',
  }) async {
    if (text.trim().isEmpty && (mediaUrl == null || mediaUrl!.isEmpty)) {
      throw ArgumentError('Post must contain text or media.');
    }
    return db.collection('posts').add({
      'authorId': uid,
      'text': text.trim(),
      'mediaUrl': mediaUrl,
      'type': type,
      'likesCount': 0,
      'commentsCount': 0,
      'sharesCount': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> likePost(String postId, bool like) async {
    final postRef = db.collection('posts').doc(postId);
    final likeRef = postRef.collection('likes').doc(uid);
    await db.runTransaction((tx) async {
      final post = await tx.get(postRef);
      final like = await tx.get(likeRef);
      final current = (post.data()?['likesCount'] as num?)?.toInt() ?? 0;
      if (like && !like.exists) {
        tx.set(likeRef, {
          'userId': uid,
          'createdAt': FieldValue.serverTimestamp(),
        });
        tx.update(postRef, {'likesCount': current + 1});
      } else if (!like && like.exists) {
        tx.delete(likeRef);
        tx.update(postRef, {'likesCount': current > 0 ? current - 1 : 0});
      }
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> postLikes(String postId) =>
      db.collection('posts').doc(postId).collection('likes').snapshots();

  Future<void> addComment(String postId, String text) async {
    final clean = text.trim();
    if (clean.isEmpty) throw ArgumentError('Comment cannot be empty.');
    final postRef = db.collection('posts').doc(postId);
    final commentRef = postRef.collection('comments').doc();
    await db.runTransaction((tx) async {
      final post = await tx.get(postRef);
      final count = (post.data()?['commentsCount'] as num?)?.toInt() ?? 0;
      tx.set(commentRef, {
        'authorId': uid,
        'text': clean,
        'createdAt': FieldValue.serverTimestamp(),
      });
      tx.update(postRef, {'commentsCount': count + 1});
    });
  }

  Future<void> follow(String targetUid, bool shouldFollow) async {
    if (targetUid == uid) throw ArgumentError('Cannot follow yourself.');
    final followingRef =
        db.collection('users').doc(uid).collection('following').doc(targetUid);
    final followerRef =
        db.collection('users').doc(targetUid).collection('followers').doc(uid);
    final batch = db.batch();
    if (shouldFollow) {
      final data = {'createdAt': FieldValue.serverTimestamp()};
      batch.set(followingRef, data);
      batch.set(followerRef, data);
    } else {
      batch.delete(followingRef);
      batch.delete(followerRef);
    }
    await batch.commit();
  }

  Future<void> createStory({
    required String mediaUrl,
    String type = 'image',
  }) => db.collection('stories').add({
        'authorId': uid,
        'mediaUrl': mediaUrl,
        'type': type,
        'createdAt': FieldValue.serverTimestamp(),
        'expiresAt':
            Timestamp.fromDate(DateTime.now().add(const Duration(hours: 24))),
      });

  Future<void> createReel({
    required String mediaUrl,
    String caption = '',
  }) => db.collection('reels').add({
        'authorId': uid,
        'mediaUrl': mediaUrl,
        'caption': caption.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'likesCount': 0,
        'commentsCount': 0,
      });

  Future<void> sendMessage(
    String conversationId,
    String text, {
    String type = 'text',
  }) async {
    final clean = text.trim();
    if (clean.isEmpty) throw ArgumentError('Message cannot be empty.');
    await db
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .add({
      'senderId': uid,
      'text': clean,
      'type': type,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> chat(String conversationId) =>
      db
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .orderBy('createdAt')
          .snapshots();

  Future<void> createNotification({
    required String recipientId,
    required String type,
    required String text,
  }) => db
      .collection('notifications')
      .add({
        'userId': recipientId,
        'actorId': uid,
        'type': type,
        'text': text,
        'read': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

  Stream<QuerySnapshot<Map<String, dynamic>>> notifications() => db
      .collection('notifications')
      .where('userId', isEqualTo: uid)
      .orderBy('createdAt', descending: true)
      .limit(100)
      .snapshots();

  Future<void> markNotificationRead(String notificationId) =>
      db.collection('notifications').doc(notificationId).update({'read': true});

  Future<void> report({
    required String targetType,
    required String targetId,
    required String reason,
  }) async {
    final clean = reason.trim();
    if (clean.isEmpty) throw ArgumentError('Report reason is required.');
    await db.collection('reports').add({
      'reporterId': uid,
      'targetType': targetType,
      'targetId': targetId,
      'reason': clean,
      'status': 'open',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> block(String targetUid) => db
      .collection('users')
      .doc(uid)
      .collection('blocked')
      .doc(targetUid)
      .set({'createdAt': FieldValue.serverTimestamp()});

  Future<void> submitPayout({
    required int amountPaise,
    required String method,
  }) async {
    if (amountPaise <= 0) throw ArgumentError('Payout amount must be positive.');
    await db.collection('payoutRequests').add({
      'userId': uid,
      'amountPaise': amountPaise,
      'method': method.trim(),
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> createSubscriptionPlan({
    required String name,
    required int pricePaise,
  }) async {
    if (name.trim().isEmpty || pricePaise <= 0) {
      throw ArgumentError('Valid plan name and price are required.');
    }
    await db.collection('users').doc(uid).collection('subscriptionPlans').add({
      'name': name.trim(),
      'pricePaise': pricePaise,
      'active': true,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> createProduct({
    required String name,
    required int pricePaise,
    int stock = 0,
  }) async {
    if (name.trim().isEmpty || pricePaise <= 0 || stock < 0) {
      throw ArgumentError('Valid product data is required.');
    }
    await db.collection('products').add({
      'sellerId': uid,
      'name': name.trim(),
      'pricePaise': pricePaise,
      'stock': stock,
      'active': true,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
  /// Records a verified playback session for a video/reel.
  /// The server/security rules should validate author ownership and prevent
  /// abusive or duplicated events before counting them as monetized analytics.
  Future<void> recordVideoWatch({
    required String videoId,
    required String contentType,
    required int watchedSeconds,
    required int positionSeconds,
    bool completed = false,
  }) async {
    if (videoId.trim().isEmpty) throw ArgumentError('Video ID is required.');
    if (watchedSeconds < 0 || positionSeconds < 0) {
      throw ArgumentError('Watch times cannot be negative.');
    }
    await db.collection('videoWatchEvents').add({
      'videoId': videoId.trim(),
      'contentType': contentType,
      'viewerId': uid,
      'watchedSeconds': watchedSeconds,
      'positionSeconds': positionSeconds,
      'completed': completed,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Reads server-produced creator analytics. This stream must be populated
  /// by trusted backend aggregation/Cloud Functions, not by client-side
  /// earnings calculations.
  Stream<DocumentSnapshot<Map<String, dynamic>>> creatorVideoAnalytics(
      String videoId) =>
      db.collection('videoAnalytics').doc(videoId).snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> creatorAnalytics() => db
      .collection('creatorAnalytics')
      .where('creatorId', isEqualTo: uid)
      .snapshots();

}
