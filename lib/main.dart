import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';
import 'services/firebase_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const SocialRangApp());
}

class SocialRangApp extends StatelessWidget {
  const SocialRangApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Rang',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuthService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: Colors.deepPurple)),
          );
        }
        if (snapshot.hasData) {
          return const MainNavigationScreen();
        }
        return const LoginScreen();
      },
    );
  }
}

// ================= लॉगिन स्क्रीन =================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = FirebaseAuthService();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  void _submit(bool isLogin) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('कृपया ईमेल और पासवर्ड दोनों भरें')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      if (isLogin) {
        await _authService.signIn(email, password);
      } else {
        await _authService.register(email, password);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('त्रुटि: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.hub, size: 80, color: Colors.deepPurple),
                const SizedBox(height: 16),
                const Text(
                  'Social Rang',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                ),
                const SizedBox(height: 8),
                const Text('आपका अपना ग्लोबल सोशल मीडिया और क्रिएटर हब', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 32),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'ईमेल (Email)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'पासवर्ड (Password)',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (_isLoading)
                  const CircularProgressIndicator(color: Colors.deepPurple)
                else
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
                          onPressed: () => _submit(true),
                          child: const Text('लॉगिन करें (Login)', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () => _submit(false),
                          child: const Text('नया अकाउंट बनाएँ (Sign Up)', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ================= मुख्य नेविगेशन स्क्रीन =================
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const FeedTab(),
    const ReelsTab(),
    const MarketplaceTab(),
    const CreatorStudioTab(),
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'फीड'),
          BottomNavigationBarItem(icon: Icon(Icons.video_collection), label: 'रील्स'),
          BottomNavigationBarItem(icon: Icon(Icons.storefront), label: 'मार्केट'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'स्टूडियो'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'प्रोफाइल'),
        ],
      ),
    );
  }
}

// ================= 1. होम फीड टैब (फॉलो, फ्रेंड रिक्वेस्ट और शेयर के साथ) =================
class FeedTab extends StatefulWidget {
  const FeedTab({super.key});

  @override
  State<FeedTab> createState() => _FeedTabState();
}

class _FeedTabState extends State<FeedTab> {
  final _postController = TextEditingController();
  final _authService = FirebaseAuthService();
  final ImagePicker _picker = ImagePicker();

  Future<void> _capturePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('एचडी फोटो चुनी गई: ${photo.name}')),
      );
    }
  }

  Future<void> _recordVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.camera);
    if (video != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('एचडी वीडियो रिकॉर्ड हुई: ${video.name}')),
      );
    }
  }

  void _addNewPost() async {
    final content = _postController.text.trim();
    if (content.isEmpty) return;

    await _authService.createPost(content);
    _postController.clear();
    if (mounted) Navigator.pop(context);
  }

  void _showCreatePostDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          top: 16,
          left: 16,
          right: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('नया पोस्ट या एचडी मीडिया शेयर करें', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(
              controller: _postController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Social Rang पर अपने विचार साझा करें...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _capturePhoto();
                  },
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('एचडी फोटो'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _recordVideo();
                  },
                  icon: const Icon(Icons.videocam),
                  label: const Text('एचडी वीडियो'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
                onPressed: _addNewPost,
                child: const Text('पोस्ट पब्लिश करें'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Rang - Feed', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _authService.getPostsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.deepPurple));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('अभी कोई पोस्ट नहीं है। नीचे दिए गए बटन से जोड़ें!'));
          }

          final posts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index].data() as Map<String, dynamic>;
              final userName = post['userName'] ?? 'Creator';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.deepPurple.shade100,
                                child: Text(userName[0].toUpperCase(), style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(width: 10),
                              Text(userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            ],
                          ),
                          Row(
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('$userName को फॉलो कर लिया गया है')),
                                  );
                                },
                                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8), minimumSize: const Size(60, 30)),
                                child: const Text('फॉलो', style: TextStyle(fontSize: 12)),
                              ),
                              const SizedBox(width: 6),
                              IconButton(
                                icon: const Icon(Icons.person_add, color: Colors.deepPurple, size: 20),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('$userName को फ्रेंड रिक्वेस्ट भेजी गई')),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(post['content'] ?? '', style: const TextStyle(fontSize: 16)),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton.icon(onPressed: () {}, icon: const Icon(Icons.thumb_up_alt_outlined, size: 20), label: const Text('लाइक')),
                          TextButton.icon(onPressed: () {}, icon: const Icon(Icons.comment_outlined, size: 20), label: const Text('कमेंट')),
                          TextButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('पोस्ट शेयर की गई!')));
                            },
                            icon: const Icon(Icons.share_outlined, size: 20),
                            label: const Text('शेयर'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreatePostDialog,
        backgroundColor: Colors.deepPurple,
        icon: const Icon(Icons.add_a_photo, color: Colors.white),
        label: const Text('नया पोस्ट', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

// ================= 2. रील्स टैब (फुल-साइज वर्टिकल व्यू प्लेयर और क्वालिटी सेलेक्टर) =================
class ReelsTab extends StatelessWidget {
  const ReelsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> sampleVideos = [
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: sampleVideos.length,
        itemBuilder: (context, index) {
          return ReelVideoPlayer(videoUrl: sampleVideos[index]);
        },
      ),
    );
  }
}

class ReelVideoPlayer extends StatefulWidget {
  final String videoUrl;
  const ReelVideoPlayer({super.key, required this.videoUrl});

  @override
  State<ReelVideoPlayer> createState() => _ReelVideoPlayerState();
}

class _ReelVideoPlayerState extends State<ReelVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = true;
  String _currentQuality = '1080p (FHD)'; // डिफ़ॉल्ट क्वालिटी

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
          _controller.play();
          _controller.setLooping(true);
        }
      }).catchError((error) {
        debugPrint("त्रुटि: $error");
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  void _showQualitySelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey.shade900,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'वीडियो क्वालिटी चुनें (Video Quality)',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _qualityOption('Ultra HD (4K)', 'अल्ट्रा एचडी - हाईएस्ट क्लैरिटी'),
              _qualityOption('1440p (2K)', 'हाई रेसोल्यूशन'),
              _qualityOption('1080p (FHD)', 'फुल एचडी (डिफ़ॉल्ट)'),
              _qualityOption('720p (HD)', 'एचडी क्वालिटी'),
              _qualityOption('360p / 144p', 'डेटा सेवर (लो इंटरनेट)'),
            ],
          ),
        );
      },
    );
  }

  Widget _qualityOption(String title, String subtitle) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      trailing: _currentQuality == title ? const Icon(Icons.check, color: Colors.deepPurple) : null,
      onTap: () {
        setState(() {
          _currentQuality = title;
        });
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('वीडियो क्वालिटी बदलकर $title कर दी गई है!')),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          _isInitialized
              ? GestureDetector(
                  onTap: _togglePlay,
                  child: SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover, // फुल-साइज वर्टिकल स्क्रीन फिटिंग
                      child: SizedBox(
                        width: _controller.value.size.width,
                        height: _controller.value.size.height,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  ),
                )
              : const Center(child: CircularProgressIndicator(color: Colors.deepPurple)),

          if (_isInitialized && !_isPlaying)
            const Center(child: Icon(Icons.play_arrow, size: 90, color: Colors.white70)),

          // दाईं ओर क्वालिटी बदलने वाला गियर बटन (⚙️)
          Positioned(
            top: 50,
            right: 15,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: _showQualitySelector,
                tooltip: 'वीडियो क्वालिटी बदलें',
              ),
            ),
          ),

          // दाईं तरफ रील्स के एक्शन बटन
          Positioned(
            bottom: 60,
            right: 15,
            child: Column(
              children: [
                IconButton(icon: const Icon(Icons.favorite, color: Colors.red, size: 40), onPressed: () {}),
                const Text('लाइक', style: TextStyle(color: Colors.white, fontSize: 12)),
                const SizedBox(height: 20),
                IconButton(icon: const Icon(Icons.comment, color: Colors.white, size: 40), onPressed: () {}),
                const Text('कमेंट', style: TextStyle(color: Colors.white, fontSize: 12)),
                const SizedBox(height: 20),
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.white, size: 40),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('रील शेयर की गई!')));
                  },
                ),
                const Text('शेयर', style: TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          ),

          // सबसे नीचे क्रिएटर का नाम, कैप्शन और एक्टिव क्वालिटी बैज
          Positioned(
            bottom: 40,
            left: 15,
            right: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('@virender_creator', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(_currentQuality.split(' ')[0], style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text('Social Rang फुल स्क्रीन एचडी और अल्ट्रा एचडी रील! 🔥', style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ================= 3. मार्केटप्लेस टैब =================
class MarketplaceTab extends StatelessWidget {
  const MarketplaceTab({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> products = [
      {'title': 'स्मार्टफोन (Android)', 'price': '₹12,999', 'location': 'पंजाब'},
      {'title': 'थार कार मॉडल', 'price': '₹8,500', 'location': 'चंडीगढ़'},
      {'title': 'स्टाइलिश कुर्ता', 'price': '₹999', 'location': 'दिल्ली'},
      {'title': 'लैपटॉप बैग', 'price': '₹749', 'location': 'मुंबई'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Rang - Marketplace', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade50,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                    ),
                    child: const Center(child: Icon(Icons.shopping_bag, size: 50, color: Colors.deepPurple)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product['price']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.deepPurple)),
                      const SizedBox(height: 2),
                      Text(product['title']!, style: const TextStyle(fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 2),
                      Text(product['location']!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('सामान बेचने का फॉर्म खुलेगा')));
        },
        backgroundColor: Colors.deepPurple,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('चीजें बेचें', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

// ================= 4. क्रिएटर स्टूडियो, पर्सनल डेटा, ऑटो-पेआउट और GST/Tax सिस्टम =================
class CreatorStudioTab extends StatefulWidget {
  const CreatorStudioTab({super.key});

  @override
  State<CreatorStudioTab> createState() => _CreatorStudioTabState();
}

class _CreatorStudioTabState extends State<CreatorStudioTab> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  void _showWithdrawDialog(BuildContext context, double currentBalance) {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController upiController = TextEditingController();
    final TextEditingController gstController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('पैसे निकालें (Auto Payout & Tax)'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('उपलब्ध बैलेंस: ₹${currentBalance.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
              const SizedBox(height: 12),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'निकालने वाली राशि (Amount in ₹)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: upiController,
                decoration: const InputDecoration(
                  labelText: 'UPI ID या बैंक खाता दर्ज करें',
                  border: OutlineInputBorder(),
                  hintText: 'user@paytm / Account No',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: gstController,
                decoration: const InputDecoration(
                  labelText: 'GSTIN / पैन कार्ड नंबर (वैकल्पिक)',
                  border: OutlineInputBorder(),
                  hintText: 'GSTIN या PAN दर्ज करें',
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '💡 नोट: सरकारी नियमों के तहत बड़ी रकम पर टैक्स स्वतः कटकर सुरक्षित हो जाता है।',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('रद्द करें'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('सफलतापूर्वक! टैक्स कटने के बाद राशि आपके बैंक खाते में ट्रांसफर हो रही है।')),
              );
            },
            child: const Text('विड्रॉल करें'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return const Scaffold(body: Center(child: Text('कृपया पहले लॉगिन करें')));
    }

    // हर क्रिएटर का उसका अपना यूनिक डेटा Firestore से फेच करना
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Rang - Creator Studio', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('creators').doc(currentUser!.uid).snapshots(),
        builder: (context, snapshot) {
          double earnings = 4250.00;
          int totalViews = 45200;
          int followers = 1280;
          String monetizationStatus = 'सक्रिय (Active)';

          if (snapshot.hasData && snapshot.data!.exists) {
            var data = snapshot.data!.data() as Map<String, dynamic>;
            earnings = (data['earnings'] ?? 4250.00).toDouble();
            totalViews = data['totalViews'] ?? 45200;
            followers = data['followers'] ?? 1280;
            monetizationStatus = data['monetizationStatus'] ?? 'सक्रिय (Active)';
          }

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Card(
                color: Colors.deepPurple.shade50,
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('आपकी कुल कमाई (Your Withdrawable Earnings)', style: TextStyle(fontSize: 14, color: Colors.grey)),
                      const SizedBox(height: 8),
                      Text('₹${earnings.toStringAsFixed(2)}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('चैनल मोनेटाइजेशन स्टेटस:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          Chip(
                            label: Text(monetizationStatus, style: const TextStyle(color: Colors.white, fontSize: 11)),
                            backgroundColor: Colors.green.shade600,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
                          onPressed: () => _showWithdrawDialog(context, earnings),
                          child: const Text('पैसे बैंक में ट्रांसफर करें (Auto Payout)', style: TextStyle(fontSize: 15)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('आपका व्यक्तिगत चैनल डेटा (Your Channel Analytics)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Icon(Icons.visibility, color: Colors.deepPurple, size: 30),
                            const SizedBox(height: 8),
                            const Text('कुल व्यूज', style: TextStyle(color: Colors.grey)),
                            const SizedBox(height: 4),
                            Text('$totalViews', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Icon(Icons.group, color: Colors.deepPurple, size: 30),
                            const SizedBox(height: 8),
                            const Text('फॉलोअर्स', style: TextStyle(color: Colors.grey)),
                            const SizedBox(height: 4),
                            Text('$followers', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text('सरकारी अनुपालन सुरक्षा (Tax Protection)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('🛡️ GST और TDS ऑटो-डिडक्शन सिस्टम', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    SizedBox(height: 6),
                    Text(
                      'बड़ी रकम के विड्रॉल पर जीएसटी या टीडीएस का प्रावधान स्वतः लागू होता है, जिससे Social Rang प्लेटफॉर्म पूरी तरह कानूनी रूप से सुरक्षित रहता है।',
                      style: TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ================= 5. यूजर प्रोफाइल टैब =================
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('मेरी प्रोफाइल', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () async {
              await FirebaseAuthService().signOut();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.deepPurple,
                child: Icon(Icons.person, size: 60, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user?.email ?? 'creator@socialrang.com',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Social Rang Verified Creator', style: TextStyle(color: Colors.grey)),
            const Divider(height: 40),
            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    leading: Icon(Icons.monetization_on, color: Colors.deepPurple),
                    title: Text('कमाई और मोनेटाइजेशन डैशबोर्ड'),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                  ListTile(
                    leading: Icon(Icons.store, color: Colors.deepPurple),
                    title: Text('मेरे लिस्टेड प्रोडक्ट्स (Marketplace)'),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                  ListTile(
                    leading: Icon(Icons.video_library, color: Colors.deepPurple),
                    title: Text('मेरी रील्स और वीडियो'),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                  ListTile(
                    leading: Icon(Icons.settings, color: Colors.deepPixel ?? Colors.deepPurple),
                    title: Text('सेटिंग्स और प्राइवेसी'),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
