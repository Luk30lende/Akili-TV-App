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
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            // ============================================================
            // HEADER
            // ============================================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Color(0xFFEFEFEF), width: 1),
                ),
              ),
              child: Center(
                child: Image.asset('assets/images/tv_logo.png', width: 105),
              ),
            ),

            // ============================================================
            // HERO SECTION
            // ============================================================
            Expanded(
              child: Stack(
                children: [
                  // ------------------------------------------------------
                  // BACKGROUND IMAGE
                  // ------------------------------------------------------
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/hero.png',
                      fit: BoxFit.cover,
                    ),
                  ),

                  // ------------------------------------------------------
                  // DARK CINEMATIC OVERLAY
                  // ------------------------------------------------------
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF000000).withValues(alpha: 0.82),
                            const Color(0xFF000000).withValues(alpha: 0.55),
                            const Color(0xFF000000).withValues(alpha: 0.30),
                          ],
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                        ),
                      ),
                    ),
                  ),

                  // ------------------------------------------------------
                  // CONTENT
                  // ------------------------------------------------------
                  Positioned(
                    left: 22,
                    right: 22,
                    bottom: 35,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --------------------------------------------------
                        // LIVE NOW
                        // --------------------------------------------------
                        Row(
                          children: [
                            Container(
                              width: 9,
                              height: 9,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 255, 56, 56),
                                shape: BoxShape.circle,
                              ),
                            ),

                            const SizedBox(width: 7),

                            const Text(
                              'LIVE NOW',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                color: Color.fromARGB(255, 255, 29, 29),
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // --------------------------------------------------
                        // TITLE
                        // --------------------------------------------------
                        const Text(
                          'Watch Akili TV\nLive',
                          style: TextStyle(
                            fontFamily: 'PublicSans',
                            fontSize: 46,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -1.4,
                            height: 1.08,
                          ),
                        ),

                        const SizedBox(height: 14),

                        // --------------------------------------------------
                        // DESCRIPTION
                        // --------------------------------------------------
                        const Text(
                          'Streaming 24/7 family-friendly entertainment.',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),

                        const SizedBox(height: 22),

                        // --------------------------------------------------
                        // WATCH LIVE BUTTON
                        // --------------------------------------------------
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: onWatchLive,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF2D2D),
                              foregroundColor: Colors.white,
                              elevation: 4,
                              shadowColor: Colors.black54,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.play_arrow_rounded,
                                  size: 23,
                                  color: Colors.white,
                                ),

                                SizedBox(width: 8),

                                Text(
                                  'Watch Live',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 17,
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
