import 'package:flutter/material.dart';
import 'dart:async'; // To use timers

class ChatLoadingScreen extends StatefulWidget {
  @override
  _ChatLoadingScreenState createState() => _ChatLoadingScreenState();
}

class _ChatLoadingScreenState extends State<ChatLoadingScreen> {
  // To manage the fade in and out effect
  double _opacity = 0.0;
  bool _fadingIn = true; // Track whether it's fading in or out
  Timer? _fadeTimer; // Timer to handle the fade effect

  @override
  void initState() {
    super.initState();
    // Start the animation cycle
    _startFadeAnimation();
  }

  void _startFadeAnimation() {
    _fadeTimer = Timer.periodic(Duration(milliseconds: 1500), (timer) {
      if (mounted) {
        setState(() {
          _opacity = _fadingIn ? 1.0 : 0.0;
          _fadingIn = !_fadingIn;
        });
      }
    });
  }

  @override
  void dispose() {
    // Cancel the timer to prevent memory leaks
    _fadeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          // Simulating a pull to refresh effect
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return AnimatedOpacity(
                  opacity: _opacity,
                  duration: Duration(seconds: 1), // Controls the speed of the fade
                  child: _buildLoadingChatTile(),
                );
              },
              childCount: 10, // Number of tiles to display
            ),
          ),
        ],
      ),
    );
  }

  // Simulated chat tile layout
  Widget _buildLoadingChatTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.black87, // Dark background to mimic your real tiles
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: Offset(0, 4),
              blurRadius: 6,
            ),
          ],
        ),
        child: Row(
          children: [
            // Circle avatar placeholder
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey[700],
            ),
            SizedBox(width: 15),
            // Placeholder text for name and message
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name placeholder
                  Container(
                    width: 150,
                    height: 16,
                    color: Colors.grey[600], // Placeholder color
                  ),
                  SizedBox(height: 8),
                  // Last message placeholder
                  Container(
                    width: 200,
                    height: 14,
                    color: Colors.grey[700], // Placeholder color
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
            // Placeholder for timestamp
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Placeholder for time
                Container(
                  width: 40,
                  height: 12,
                  color: Colors.grey[700], // Placeholder color
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
