import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const SocialRangApp());
}

ValueNotifier<Locale> appLanguageNotifier = ValueNotifier<Locale>(const Locale('hi'));

class SocialRangApp extends StatelessWidget {
  const SocialRangApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: appLanguageNotifier,
      builder: (context, currentLocale, child) {
        return MaterialApp(
          title: 'Social Rang',
          debugShowCheckedModeBanner: false,
          locale: currentLocale,
          theme: ThemeData(
            primaryColor: const Color(0xFF1877F2),
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: const Color(0xFF1877F2),
              secondary: const Color(0xFFFD1D1D),
            ),
            scaffoldBackgroundColor: const Color(0xFFF0F2F5),
          ),
          // अब ऐप डायरेक्ट होम पर नहीं, बल्कि लॉगिन स्क्रीन पर खुलेगा
          home: const LoginScreen(), 
        );
      },
    );
  }
}

// ==========================================
// 🔐 1. LOGIN & SIGNUP SCREEN (Email & Phone OTP)
// ==========================================
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = true; // True = Login, False = Sign Up
  bool isPhoneAuth = false; // True = OTP Login, False = Email Login
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  
  String _verificationId = "";
  bool _otpSent = false;

  // होम स्क्रीन पर जाने का फंक्शन
  void _goToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainHomeScreen()),
    );
  }

  // OTP भेजने का डमी फंक्शन (Firebase setup के बाद असली OTP काम करेगा)
  void _sendOTP() {
    if (_phoneController.text.length >= 10) {
      setState(() {
        _otpSent = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('📲 OTP आपके नंबर पर भेज दिया गया है! (Demo)')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ कृपया सही मोबाइल नंबर दर्ज करें'), backgroundColor: Colors.red),
      );
    }
  }

  // OTP वेरीफाई करने का फंक्शन
  void _verifyOTP() {
    if (_otpController.text.length == 6) {
      _goToHome();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ अमान्य OTP! कृपया सही OTP डालें।'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              // App Logo / Name
              const Text(
                'social rang',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1877F2),
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                isLogin ? 'लॉगिन करें' : 'नया अकाउंट बनाएं',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 40),

              // Toggle Between Email and Phone
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChoiceChip(
                    label: const Text('ईमेल से'),
                    selected: !isPhoneAuth,
                    onSelected: (val) => setState(() => isPhoneAuth = false),
                    selectedColor: const Color(0xFFE7F3FF),
                    labelStyle: TextStyle(color: !isPhoneAuth ? const Color(0xFF1877F2) : Colors.black),
                  ),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    label: const Text('मोबाइल नंबर (OTP)'),
                    selected: isPhoneAuth,
                    onSelected: (val) => setState(() => isPhoneAuth = true),
                    selectedColor: const Color(0xFFE7F3FF),
                    labelStyle: TextStyle(color: isPhoneAuth ? const Color(0xFF1877F2) : Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Phone Number & OTP UI
              if (isPhoneAuth) ...[
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'मोबाइल नंबर',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                if (_otpSent) ...[
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: '6-अंकों का OTP दर्ज करें',
                      prefixIcon: Icon(Icons.security),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1877F2), padding: const EdgeInsets.symmetric(vertical: 14)),
                    onPressed: _verifyOTP,
                    child: const Text('OTP वेरिफाई करें और लॉगिन करें', style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ] else ...[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1877F2), padding: const EdgeInsets.symmetric(vertical: 14)),
                    onPressed: _sendOTP,
                    child: const Text('OTP भेजें', style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ]
              ],

              // Email & Password UI
              if (!isPhoneAuth) ...[
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'ईमेल एड्रेस', prefixIcon: Icon(Icons.email), border: OutlineInputBorder()),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'पासवर्ड', prefixIcon: Icon(Icons.lock), border: OutlineInputBorder()),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1877F2), padding: const EdgeInsets.symmetric(vertical: 14)),
                  onPressed: _goToHome,
                  child: Text(isLogin ? 'लॉगिन करें' : 'अकाउंट बनाएं', style: const TextStyle(fontSize: 16, color: Colors.white)),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isLogin = !isLogin; // Toggle Login / Signup
                    });
                  },
                  child: Text(isLogin ? 'नया अकाउंट बनाएं? साइन अप करें' : 'पहले से अकाउंट है? लॉगिन करें'),
                )
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 🛡️ 2. PROFANITY FILTER (गाली-गलौज रोकने का सिस्टम)
// ==========================================
class ContentModerator {
  static final List<String> _blockedWords = ['abuse_word_1', 'abuse_word_2'];

  static bool containsProfanity(String text) {
    String lowerText = text.toLowerCase();
    for (String word in _blockedWords) {
      if (lowerText.contains(word)) return true; 
    }
    return false; 
  }
}

// ==========================================
// 📱 3. MAIN HOME SCREEN (ऐप का मुख्य हिस्सा)
// ==========================================
class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({Key? key}) : super(key: key);

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const FeedScreen(),
    const ReelsScreen(),
    const MarketScreen(),
    const StudioScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1877F2),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'होम'),
          BottomNavigationBarItem(icon: Icon(Icons.slow_motion_video), label: 'रील्स'),
          BottomNavigationBarItem(icon: Icon(Icons.storefront), label: 'मार्केट'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'स्टूडियो'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'मेनू'),
        ],
      ),
    );
  }
}

// ==========================================
// 📰 4. HOME FEED & FILE MANAGER UPLOAD
// ==========================================
class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final TextEditingController _postController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickMediaFromFileManager(BuildContext context, {bool isVideo = false}) async {
    try {
      XFile? pickedFile = isVideo 
          ? await _picker.pickVideo(source: ImageSource.gallery) 
          : await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('📁 फाइल चुनी गई: ${pickedFile.name}. अपलोड हो रही है...')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('⚠️ फाइल चुनने में त्रुटि: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _submitPost() {
    String text = _postController.text.trim();
    if (text.isEmpty) return;

    if (ContentModerator.containsProfanity(text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ आपकी पोस्ट में आपत्तिजनक भाषा है।'), backgroundColor: Colors.red),
      );
      return;
    }

    _postController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ पोस्ट सफलतापूर्वक शेयर कर दी गई!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('social rang', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Color(0xFF1877F2), letterSpacing: -0.5)),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(icon: const Icon(Icons.search, color: Colors.black87), onPressed: () {}),
          IconButton(icon: const Icon(Icons.chat_bubble, color: Colors.black87), onPressed: () {}),
        ],
      ),
      body: ListView(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    const CircleAvatar(backgroundColor: Color(0xFF1877F2), child: Text('VR', style: TextStyle(color: Colors.white))),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _postController,
                        decoration: const InputDecoration(hintText: 'कुछ लिखें...', border: InputBorder.none),
                      ),
                    ),
                    IconButton(icon: const Icon(Icons.send, color: Color(0xFF1877F2)), onPressed: _submitPost),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton.icon(onPressed: () {}, icon: const Icon(Icons.videocam, color: Colors.red), label: const Text('लाइव', style: TextStyle(color: Colors.black87))),
                    TextButton.icon(onPressed: () => _pickMediaFromFileManager(context, isVideo: true), icon: const Icon(Icons.video_library, color: Colors.green), label: const Text('वीडियो', style: TextStyle(color: Colors.black87))),
                    TextButton.icon(onPressed: () => _pickMediaFromFileManager(context, isVideo: false), icon: const Icon(Icons.photo_library, color: Colors.blue), label: const Text('फोटो', style: TextStyle(color: Colors.black87))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Sample Post
          Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            color: Colors.white,
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('वीरेंद्र कुमार', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 5),
                Text('Social Rang में लॉगिन, OTP, फाइल मैनेजर और सुरक्षा सिस्टम एक्टिव है! 🚀', style: TextStyle(fontSize: 15)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// ==========================================
// 🎬 5. REELS SCREEN 
// ==========================================
class ReelsScreen extends StatelessWidget {
  const ReelsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('रील्स'), backgroundColor: Colors.white, foregroundColor: Colors.black),
      body: const Center(child: Text('रील्स फीड', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
    );
  }
}

// 🛒 6. MARKETPLACE
class MarketScreen extends StatelessWidget {
  const MarketScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('मार्केटप्लेस')), body: const Center(child: Text('खरीद-बिक्री')));
  }
}

// 💰 7. CREATOR STUDIO
class StudioScreen extends StatelessWidget {
  const StudioScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Creator Studio')), body: const Center(child: Text('मोनेटाइजेशन')));
  }
}

// 👤 8. PROFILE / MENU (with Logout)
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('मेनू'), backgroundColor: Colors.white, foregroundColor: Colors.black),
      body: ListView(
        children: [
          const ListTile(
            leading: CircleAvatar(backgroundColor: Color(0xFF1877F2), child: Text('VR', style: TextStyle(color: Colors.white))),
            title: Text('वीरेंद्र कुमार', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('आपकी प्रोफाइल'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('लॉगआउट (Logout)'),
            onTap: () {
              // लॉगआउट करके वापस लॉगिन स्क्रीन पर जाना
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
          ),
        ],
      ),
    );
  }
}
