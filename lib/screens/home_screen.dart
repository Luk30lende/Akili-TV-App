import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onWatchLive;
  const HomeScreen({super.key, required this.onWatchLive});

  Future<void> openStream() async {
    final Uri url = Uri.parse('https://smccdn.com/akilikids.co.ke/');

    if (!await launchUrl(url, mode: LaunchMode.platformDefault)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      backgroundColor: Colors.white,

      // 🔹 BODY
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 HEADER
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFFF0F0F0), // light grey
                    width: 1,
                  ),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // LOGO
                  Image.asset('assets/images/tv_logo.png', width: 100),
                ],
              ),
            ),

            // 🔹 HERO SECTION
            Expanded(
              child: Stack(
                children: [
                  // BACKGROUND IMAGE
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/hero.png', // 👈 ADD THIS IMAGE
                      fit: BoxFit.contain,
                    ),
                  ),

                  // DARK OVERLAY
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF0E0E0E).withValues(alpha: 0.75),
                            const Color(0xFF0E0E0E).withValues(alpha: 0.65),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.center,
                        ),
                      ),
                    ),
                  ),

                  // CONTENT
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // LIVE NOW
                        Row(
                          children: const [
                            Icon(
                              Icons.circle,
                              color: Color(0xFFF44335),
                              size: 10,
                            ),
                            SizedBox(width: 6),
                            Text(
                              "LIVE NOW",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                color: Color(0xFFF44335),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // TITLE
                        const Text(
                          "Watch Akili TV\nLive",
                          style: TextStyle(
                            fontFamily: 'PublicSans',
                            fontSize: 48,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -1.2,
                            height: 1.2,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // SUBTEXT
                        const Text(
                          "Streaming 24/7",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // BUTTON
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF2D2D),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: onWatchLive,

                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Watch Live",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
