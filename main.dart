import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

// Global state for Hackathon Demo
bool globalAiModerationEnabled = true;

void main() {
  runApp(const CorrectuberApp());
}

class CorrectuberApp extends StatelessWidget {
  const CorrectuberApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Correctuber',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF09090E), 
        fontFamily: 'Roboto', 
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// --- 0. SPLASH SCREEN (Restored) ---
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _gradientController;
  late AnimationController _entranceController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _gradientController = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
    _entranceController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(CurvedAnimation(parent: _entranceController, curve: Curves.elasticOut));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _entranceController, curve: Curves.easeIn));

    _entranceController.forward();

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const ProfileLoginScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _gradientController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF060010),
      body: Stack(
        children: [
          Center(
            child: AnimatedBuilder(
              animation: _entranceController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: AnimatedBuilder(
                      animation: _gradientController,
                      builder: (context, child) {
                        return ShaderMask(
                          blendMode: BlendMode.srcIn,
                          shaderCallback: (bounds) {
                            return LinearGradient(
                              colors: const [Color(0xFF00FFD1), Color(0xFF39FF14), Color(0xFF00FFD1)],
                              stops: const [0.0, 0.5, 1.0],
                              begin: Alignment(-2.0 + (_gradientController.value * 2), 0),
                              end: Alignment(0.0 + (_gradientController.value * 2), 0),
                            ).createShader(bounds);
                          },
                          child: const Text("Correctuber", style: TextStyle(fontSize: 54, fontWeight: FontWeight.w900, letterSpacing: -2)),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: const Text("Developed by StacK_OverLords", style: TextStyle(color: Colors.white38, fontSize: 12, letterSpacing: 2, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- 1. CYAN & GREENISH BACKGROUND ---
class ColorBendsBackground extends StatefulWidget {
  final Widget child;
  const ColorBendsBackground({super.key, required this.child});

  @override
  State<ColorBendsBackground> createState() => _ColorBendsBackgroundState();
}

class _ColorBendsBackgroundState extends State<ColorBendsBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 8))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: const Color(0xFF060010)),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Stack(
              children: [
                Positioned(top: -100 + (_controller.value * 100), left: -50 + (_controller.value * 50), child: _buildGlow(const Color(0xFF00FFD1))),
                Positioned(bottom: -150 + ((1 - _controller.value) * 100), right: -100 + (_controller.value * 150), child: _buildGlow(const Color(0xFF39FF14))),
                Positioned(top: 200 + ((1 - _controller.value) * 100), left: 100 + ((1 - _controller.value) * 50), child: _buildGlow(const Color(0xFF008080))),
              ],
            );
          },
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 80.0, sigmaY: 80.0),
          child: Container(color: Colors.transparent),
        ),
        widget.child,
      ],
    );
  }

  Widget _buildGlow(Color color) {
    return Container(width: 400, height: 400, decoration: BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(0.4)));
  }
}

// --- 2. LOGIN SCREEN ---
class ProfileLoginScreen extends StatefulWidget {
  const ProfileLoginScreen({super.key});

  @override
  State<ProfileLoginScreen> createState() => _ProfileLoginScreenState();
}

class _ProfileLoginScreenState extends State<ProfileLoginScreen> {
  bool _otpSent = false;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  String _selectedLanguage = 'English';
  String _selectedCountry = 'India';

  void _verifyLogin() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ChatRoomsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ColorBendsBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 60.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.stream, size: 48, color: Color(0xFF00FFD1)),
                const SizedBox(height: 24),
                const Text("Correctuber", style: TextStyle(fontSize: 42, fontWeight: FontWeight.w900, letterSpacing: -1.5, color: Colors.white)),
                const Text("Connect seamlessly.", style: TextStyle(fontSize: 18, color: Colors.white70)),
                const SizedBox(height: 48),

                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedLanguage,
                        dropdownColor: const Color(0xFF1E1E28),
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration("Language"),
                        items: ['English', 'Spanish', 'French', 'Hindi'].map((String val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
                        onChanged: (val) => setState(() => _selectedLanguage = val!),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedCountry,
                        dropdownColor: const Color(0xFF1E1E28),
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration("Country"),
                        items: ['India', 'USA', 'UK', 'Canada'].map((String val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
                        onChanged: (val) => setState(() => _selectedCountry = val!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration("Phone Number").copyWith(prefixIcon: const Icon(Icons.phone, color: Colors.white54)),
                ),
                const SizedBox(height: 24),

                if (_otpSent) ...[
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration("Enter 6-digit OTP").copyWith(prefixIcon: const Icon(Icons.lock_outline, color: Colors.white54)),
                  ),
                  const SizedBox(height: 32),
                ],

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00FFD1),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 10,
                      shadowColor: const Color(0xFF00FFD1).withOpacity(0.5),
                    ),
                    onPressed: _otpSent ? _verifyLogin : () => setState(() => _otpSent = true),
                    child: Text(_otpSent ? 'Enter Platform' : 'Send Code', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white54),
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF00FFD1))),
    );
  }
}

// --- 3. CHAT ROOMS SCREEN ---
class ChatRoomsScreen extends StatelessWidget {
  const ChatRoomsScreen({super.key});

  void _showProfileMenu(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Menu",
      pageBuilder: (context, _, __) {
        return Align(
          alignment: Alignment.topRight,
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.only(top: 80, right: 16),
              width: 200,
              decoration: BoxDecoration(color: const Color(0xFF1E1E28).withOpacity(0.9), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white10)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.person, color: Colors.white),
                    title: const Text('View Profile', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePictureScreen()));
                    },
                  ),
                  const Divider(color: Colors.white10, height: 1),
                  ListTile(
                    leading: const Icon(Icons.settings, color: Colors.white),
                    title: const Text('Settings', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09090E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Rooms", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -1)),
        actions: [
          GestureDetector(
            onTap: () => _showProfileMenu(context),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(backgroundImage: NetworkImage('https://i.scdn.co/image/ab67616d0000b273d9985092cd88bffd97653b58')),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _chatTile(context, "Tech Innovators", "Let's review the new AI model.", "12:00 PM", const Color(0xFF00FFD1)),
              _chatTile(context, "Design Hub", "The glass buttons look crazy.", "10:45 AM", const Color(0xFF39FF14)),
            ],
          ),
          
          Positioned(
            bottom: 30,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GlassFloatingButton(
                  icon: Icons.auto_awesome,
                  label: "AI",
                  color: const Color(0xFF39FF14),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("AI Mode Toggled!")));
                  },
                ),
                const SizedBox(height: 16),
                GlassFloatingButton(
                  icon: Icons.add,
                  color: const Color(0xFF00FFD1),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Save new contact open...")));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chatTile(BuildContext context, String title, String msg, String time, Color accent) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withOpacity(0.05))),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(radius: 26, backgroundColor: accent.withOpacity(0.2), child: Text(title[0], style: TextStyle(color: accent, fontSize: 20, fontWeight: FontWeight.bold))),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(msg, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white54)),
        trailing: Text(time, style: const TextStyle(color: Colors.white38, fontSize: 12)),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CorrectuberChatScreen(roomName: title))),
      ),
    );
  }
}

class GlassFloatingButton extends StatefulWidget {
  final IconData icon;
  final String? label;
  final Color color;
  final VoidCallback onTap;

  const GlassFloatingButton({super.key, required this.icon, this.label, required this.color, required this.onTap});

  @override
  State<GlassFloatingButton> createState() => _GlassFloatingButtonState();
}

class _GlassFloatingButtonState extends State<GlassFloatingButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(_isPressed ? 0.2 : 0.1),
          border: Border.all(color: widget.color.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: widget.color.withOpacity(_isPressed ? 0.6 : 0.2),
              blurRadius: _isPressed ? 20 : 10,
              spreadRadius: _isPressed ? 2 : 0,
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, color: widget.color, size: 28),
                if (widget.label != null) ...[
                  const SizedBox(width: 8),
                  Text(widget.label!, style: TextStyle(color: widget.color, fontWeight: FontWeight.bold, fontSize: 18)),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- 4. TILTED PROFILE PICTURE SCREEN ---
class ProfilePictureScreen extends StatefulWidget {
  const ProfilePictureScreen({super.key});

  @override
  State<ProfilePictureScreen> createState() => _ProfilePictureScreenState();
}

class _ProfilePictureScreenState extends State<ProfilePictureScreen> with SingleTickerProviderStateMixin {
  double xRotation = 0;
  double yRotation = 0;
  late AnimationController _springController;
  late Animation<double> _xAnim;
  late Animation<double> _yAnim;

  @override
  void initState() {
    super.initState();
    _springController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _springController.addListener(() {
      setState(() {
        xRotation = _xAnim.value;
        yRotation = _yAnim.value;
      });
    });
  }

  void _onPanUpdate(DragUpdateDetails details, BoxConstraints constraints) {
    if (_springController.isAnimating) _springController.stop();

    double width = 300;
    double height = 300;
    
    double offsetX = details.localPosition.dx - (width / 2);
    double offsetY = details.localPosition.dy - (height / 2);

    double rotateAmplitude = 12.0 * (math.pi / 180.0);
    
    setState(() {
      xRotation = (offsetY / (height / 2)) * -rotateAmplitude;
      yRotation = (offsetX / (width / 2)) * rotateAmplitude;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    _xAnim = Tween<double>(begin: xRotation, end: 0).animate(CurvedAnimation(parent: _springController, curve: Curves.elasticOut));
    _yAnim = Tween<double>(begin: yRotation, end: 0).animate(CurvedAnimation(parent: _springController, curve: Curves.elasticOut));
    _springController.forward(from: 0);
  }

  @override
  void dispose() {
    _springController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.transparent, title: const Text("Profile")),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return GestureDetector(
              onPanUpdate: (details) => _onPanUpdate(details, constraints),
              onPanEnd: _onPanEnd,
              child: Transform(
                alignment: FractionalOffset.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(xRotation)
                  ..rotateY(yRotation),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [BoxShadow(color: const Color(0xFF00FFD1).withOpacity(0.3), blurRadius: 40, spreadRadius: 5)],
                        image: const DecorationImage(
                          image: NetworkImage('https://i.scdn.co/image/ab67616d0000b273d9985092cd88bffd97653b58'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(yRotation * 50, -xRotation * 50),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(8)),
                        child: const Text("StacK_OverLords Team", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}

// --- 5. NEON GLOWING SETTINGS SCREEN ---
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09090E),
      appBar: AppBar(backgroundColor: Colors.transparent, title: const Text("Settings")),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: globalAiModerationEnabled ? const Color(0xFF00FFD1) : Colors.white10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("AI Moderation", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      SizedBox(height: 4),
                      Text("Automatically filter unsafe content.", style: TextStyle(color: Colors.white54)),
                    ],
                  ),
                ),
                Switch(
                  activeColor: const Color(0xFF00FFD1),
                  value: globalAiModerationEnabled,
                  onChanged: (val) => setState(() => globalAiModerationEnabled = val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _glowingSettingsItem(Icons.lock_outline, "Privacy & Security", const Color(0xFF00FFD1)),
          _glowingSettingsItem(Icons.notifications_none, "Notifications", const Color(0xFF39FF14)),
        ],
      ),
    );
  }

  Widget _glowingSettingsItem(IconData icon, String title, Color glowColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: glowColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: glowColor),
          const SizedBox(width: 16),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 16, color: Colors.white))),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white38),
        ],
      ),
    );
  }
}

// --- 6. CHAT SCREEN (Integrated AI Logic) ---
class CorrectuberChatScreen extends StatefulWidget {
  final String roomName;
  const CorrectuberChatScreen({super.key, required this.roomName});

  @override
  State<CorrectuberChatScreen> createState() => _CorrectuberChatScreenState();
}

class _CorrectuberChatScreenState extends State<CorrectuberChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() => _isTyping = _controller.text.isNotEmpty));
  }

  // Implementation of Dual Boundary Moderation [cite: 30]
  void _handleSend() {
    if (_controller.text.trim().isEmpty) return;
    String text = _controller.text.trim();
    
    if (globalAiModerationEnabled) {
      // Logic for Ethical and Topic Checks [cite: 31, 32]
      bool isAbusive = text.toLowerCase().contains("spam") || text.toLowerCase().contains("badword");
      bool isOffTopic = text.toLowerCase().contains("movie") || text.toLowerCase().contains("politics");

      if (isAbusive || isOffTopic) {
        // Smart Feedback System [cite: 33]
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: const Color(0xFFFF5C7A),
          content: Text("AI Blocked: ${isAbusive ? 'Abusive language detected.' : 'Please stay on topic.'}"),
        ));
        return;
      }
    }

    setState(() => _messages.add({"text": text, "isMe": true}));
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09090E),
      appBar: AppBar(backgroundColor: Colors.transparent, title: Text(widget.roomName)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Align(
                  alignment: msg["isMe"] ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: msg["isMe"] ? const Color(0xFF00FFD1).withOpacity(0.2) : Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: msg["isMe"] ? const Color(0xFF00FFD1).withOpacity(0.5) : Colors.transparent),
                    ),
                    child: Text(msg["text"], style: const TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.05),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _handleSend,
                  child: Container(
                    width: 52, height: 52,
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF00FFD1)),
                    child: const Icon(Icons.send, color: Colors.black),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}