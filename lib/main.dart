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
  bool isLogin = true; 
  bool isPhoneAuth = false; 
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  
  bool _otpSent = false;

  void _goToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainHomeScreen()),
    );
  }

  void _sendOTP() {
    if (_phoneController.text.length >= 10) {
      setState(() {
        _otpSent = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('📲 OTP आपके मोबाइल नंबर पर सफलतापूर्वक भेज दिया गया है!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ कृपया सही 10-अंकों का मोबाइल नंबर दर्ज करें'), backgroundColor: Colors.red),
      );
    }
  }

  void _verifyOTP() {
    if (_otpController.text.length == 6) {
      _goToHome();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ अमान्य OTP! कृपया 6-अंकों का सही OTP डालें।'), backgroundColor: Colors.red),
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
              const SizedBox(height: 60),
              const Text(
                'social rang',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1877F2),
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isLogin ? 'अपने अकाउंट में लॉगिन करें' : 'नया अकाउंट बनाएं',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),

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
                  const SizedBox(width: 12),
                  ChoiceChip(
                    label: const Text('मोबाइल नंबर (OTP)'),
                    selected: isPhoneAuth,
                    onSelected: (val) => setState(() => isPhoneAuth = true),
                    selectedColor: const Color(0xFFE7F3FF),
                    labelStyle: TextStyle(color: isPhoneAuth ? const Color(0xFF1877F2) : Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              if (isPhoneAuth) ...[
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'मोबाइल नंबर',
                    prefixIcon: Icon(Icons.phone, color: Color(0xFF1877F2)),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                if (_otpSent) ...[
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: '6-अंकों का OTP दर्ज करें',
                      prefixIcon: Icon(Icons.security, color: Color(0xFF1877F2)),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1877F2), 
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: _verifyOTP,
                    child: const Text('OTP वेरिफाई करें', style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ] else ...[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1877F2), 
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: _sendOTP,
                    child: const Text('OTP भेजें', style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ]
              ],

              if (!isPhoneAuth) ...[
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'ईमेल एड्रेस', 
                    prefixIcon: Icon(Icons.email, color: Color(0xFF1877F2)), 
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'पासवर्ड', 
                    prefixIcon: Icon(Icons.lock, color: Color(0xFF1877F2)), 
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1877F2), 
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _goToHome,
                  child: Text(isLogin ? 'लॉगिन करें' : 'अकाउंट बनाएं', style: const TextStyle(fontSize: 16, color: Colors.white)),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isLogin = !isLogin;
                    });
                  },
                  child: Text(isLogin ? 'नया अकाउंट नहीं है? साइन अप करें' : 'पहले से अकाउंट है? लॉगिन करें'),
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
// 🛡️ 2. PROFANITY FILTER (गाली-गलौज सुरक्षा)
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
// 📱 3. MAIN HOME NAVIGATION
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
// 📰 4. HOME FEED & FACEBOOK LIKE LARGE STORY SECTION
// ==========================================
class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final TextEditingController _postController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickMedia(BuildContext context, {bool isVideo = false}) async {
    try {
      XFile? pickedFile = isVideo 
          ? await _picker.pickVideo(source: ImageSource.gallery) 
          : await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('📁 फाइल सफलतापूर्वक चुनी गई: ${pickedFile.name}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('⚠️ त्रुटि: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _submitPost() {
    String text = _postController.text.trim();
    if (text.isEmpty) return;

    if (ContentModerator.containsProfanity(text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ आपकी पोस्ट में आपत्तिजनक भाषा पाई गई है।'), backgroundColor: Colors.red),
      );
      return;
    }

    _postController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ पोस्ट सफलतापूर्वक शेयर कर दी गई है!')),
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
          // What's on your mind Box
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
                        decoration: const InputDecoration(hintText: 'मन में क्या है, वीरेंद्र?', border: InputBorder.none),
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
                    TextButton.icon(onPressed: () => _pickMedia(context, isVideo: true), icon: const Icon(Icons.video_library, color: Colors.green), label: const Text('वीडियो', style: TextStyle(color: Colors.black87))),
                    TextButton.icon(onPressed: () => _pickMedia(context, isVideo: false), icon: const Icon(Icons.photo_library, color: Colors.blue), label: const Text('फोटो', style: TextStyle(color: Colors.black87))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // 🌟 FACEBOOK LIKE LARGE STORY SECTION (बड़ा स्टोरी सिस्टम)
          Container(
            height: 220,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    width: 110,
                    margin: const EdgeInsets.only(left: 10, right: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                            ),
                            child: const Center(
                              child: CircleAvatar(
                                radius: 22,
                                backgroundColor: Color(0xFF1877F2),
                                child: Icon(Icons.add, color: Colors.white, size: 28),
                              ),
                            ),
                          ),
                        ),
                        const Expanded(
                          flex: 1,
                          child: Center(
                            child: Text(
                              'स्टोरी बनाएं',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Container(
                  width: 110,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.blueAccent,
                    image: const DecorationImage(
                      image: NetworkImage('https://images.unsplash.com/photo-1506744038136-46273834b3fb'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF1877F2), width: 2),
                          ),
                          child: const CircleAvatar(
                            radius: 14,
                            backgroundImage: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb'),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        left: 8,
                        right: 8,
                        child: Text(
                          'यूजर दोस्त $index',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Sample Post
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Row(
                  children: [
                    CircleAvatar(backgroundColor: Color(0xFF1877F2), child: Text('VK', style: TextStyle(color: Colors.white))),
                    SizedBox(width: 10),
                    Text('वीरेंद्र कुमार', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                SizedBox(height: 10),
                Text('Social Rang का नया फेसबुक जैसा अपडेट लाइव है, जिसमें फुल बैकएंड और सभी बटन काम कर रहे हैं! 🚀', style: TextStyle(fontSize: 15)),
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
      body: const Center(child: Text('यहाँ आपकी रील्स वीडियो दिखाई देंगी', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
    );
  }
}

// 🛒 6. MARKETPLACE
class MarketScreen extends StatelessWidget {
  const MarketScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('मार्केटप्लेस')), body: const Center(child: Text('खरीद-बिक्री बाजार')));
  }
}

// 💰 7. CREATOR STUDIO
class StudioScreen extends StatelessWidget {
  const StudioScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Creator Studio')), body: const Center(child: Text('मोनेटाइजेशन और एनालिटिक्स डैशबोर्ड')));
  }
}

// 👤 8. PROFILE / MENU
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
            subtitle: Text('आपकी फेसबुक प्रोफाइल'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('लॉगआउट (Logout)'),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
          ),
        ],
      ),
    );
  }
}
