import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  // 1. साइन अप (यूजर का अकाउंट और Firestore प्रोफाइल बनाना)
  Future<UserCredential> register(String email, String password) async {
    UserCredential cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    
    if (cred.user != null) {
      await _db.collection('users').doc(cred.user!.uid).set({
        'uid': cred.user!.uid,
        'email': email.trim(),
        'userName': email.trim().split('@')[0],
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
    return cred;
  }

  // 2. लॉगिन
  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  // 3. लॉगआउट
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // 4. Firestore में नई पोस्ट डालना
  Future<void> createPost(String content) async {
    final user = currentUser;
    if (user == null) throw StateError('User not signed in');

    await _db.collection('posts').add({
      'userId': user.uid,
      'userEmail': user.email,
      'userName': user.email?.split('@')[0] ?? 'User',
      'content': content.trim(),
      'text': content.trim(),
      'likes': 0,
      'createdAt': FieldValue.serverTimestamp(),
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // 5. Firestore से लाइव पोस्ट्स पाना
  Stream<QuerySnapshot> getPostsStream() {
    return _db.collection('posts').orderBy('createdAt', descending: true).snapshots();
  }
}

// सोशल मीडिया फीचर्स (मैसेज, स्टोरेज, पोस्ट्स रिपॉजिटरी)
class FirebaseSocialRepository {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> posts() => db
      .collection('posts')
      .orderBy('createdAt', descending: true)
      .limit(50)
      .snapshots();

  Future<void> createPost({required String text, String? mediaUrl}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw StateError('You must be signed in.');
    await db.collection('posts').add({
      'authorId': user.uid,
      'userId': user.uid,
      'userName': user.email?.split('@')[0] ?? 'User',
      'text': text.trim(),
      'content': text.trim(),
      'mediaUrl': mediaUrl,
      'createdAt': FieldValue.serverTimestamp(),
      'timestamp': FieldValue.serverTimestamp(),
      'likesCount': 0,
      'commentsCount': 0,
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> messages(String conversationId) => db
      .collection('conversations')
      .doc(conversationId)
      .collection('messages')
      .orderBy('createdAt')
      .snapshots();

  Future<void> sendMessage(String conversationId, String text) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || text.trim().isEmpty) return;
    await db.collection('conversations').doc(conversationId).collection('messages').add({
      'senderId': user.uid,
      'text': text.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<String> uploadFile(File file, String path) async {
    final ref = storage.ref().child(path);
    await ref.putFile(file);
    return ref.getDownloadURL();
  }
}

// पुश नोटिफिकेशन्स सर्विस
class FirebaseNotificationService {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    await messaging.requestPermission(alert: true, badge: true, sound: true);
    final token = await messaging.getToken();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && token != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
        {'fcmToken': token},
        SetOptions(merge: true),
      );
    }
  }
}
