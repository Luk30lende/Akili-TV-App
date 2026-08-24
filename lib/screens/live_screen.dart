import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';

class LiveScreen extends StatefulWidget {
  final VoidCallback? onExit;

  const LiveScreen({super.key, this.onExit});

  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;

  @override
  void initState() {
    super.initState();

    if (!kIsWeb) {
      videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(
          'https://m6.livecdn.io/akilikids.co.ke/akilikids.smil/chunklist_w88071026_b2528000_slke.m3u8',
        ),
      );

      videoPlayerController!
          .initialize()
          .then((_) {
            print("Video initialized successfully");

            chewieController = ChewieController(
              videoPlayerController: videoPlayerController!,
              autoPlay: true,
              looping: true,
              showControls: true,
              allowFullScreen: true,
            );

            setState(() {});
          })
          .catchError((error) {
            print("Video initialization error: $error");
          });
    } else {
      openStream();
    }
  }

  Future<void> openStream() async {
    final Uri url = Uri.parse(
      'https://m6.livecdn.io/akilikids.co.ke/akilikids.smil/chunklist_w88071026_b2528000_slke.m3u8',
    );

    await launchUrl(url, mode: LaunchMode.platformDefault);
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ============================================================
            // VIDEO PLAYER
            // ============================================================
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                children: [
                  // ------------------------------------------------------
                  // VIDEO
                  // ------------------------------------------------------
                  if (kIsWeb)
                    const Center(
                      child: Text(
                        "Opening stream...",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  else if (chewieController != null &&
                      videoPlayerController!.value.isInitialized)
                    Chewie(controller: chewieController!)
                  else
                    const Center(
                      child: CircularProgressIndicator(color: Colors.red),
                    ),

                  // ------------------------------------------------------
                  // BACK BUTTON
                  // ------------------------------------------------------
                  Positioned(
                    top: 10,
                    left: 10,
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withOpacity(0.55),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          if (widget.onExit != null) {
                            widget.onExit!();
                          } else {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => const Scaffold(
                                  body: Center(child: Text("Loading...")),
                                ),
                              ),
                              (route) => false,
                            );
                          }
                        },
                      ),
                    ),
                  ),

                  // ------------------------------------------------------
                  // LIVE BADGE
                  // ------------------------------------------------------
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, color: Colors.white, size: 7),
                          SizedBox(width: 5),
                          Text(
                            "LIVE",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ============================================================
            // CONTENT
            // ============================================================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ------------------------------------------------------
                    // BLUE ACCENT
                    // ------------------------------------------------------
                    Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFF197FE6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ------------------------------------------------------
                    // TITLE
                    // ------------------------------------------------------
                    const Text(
                      "Akili TV Live",
                      style: TextStyle(
                        fontFamily: 'PublicSans',
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.6,
                      ),
                    ),

                    const SizedBox(height: 9),

                    // ------------------------------------------------------
                    // DESCRIPTION
                    // ------------------------------------------------------
                    const Text(
                      "Streaming 24/7 edutainment content "
                      "for the whole family.",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.black54,
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 22),

                    // ------------------------------------------------------
                    // LIVE STATUS CARD
                    // ------------------------------------------------------
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F9FC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFE8ECF2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          // LIVE ICON
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFE9E9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.live_tv,
                              color: Colors.red,
                              size: 21,
                            ),
                          ),

                          const SizedBox(width: 12),

                          // TEXT
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Currently Streaming Live",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    color: Colors.black87,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                                SizedBox(height: 4),

                                Text(
                                  "Watch anytime, 24 hours a day.",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    color: Colors.black54,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // STATUS DOT
                          Container(
                            width: 9,
                            height: 9,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ------------------------------------------------------
                    // 24/7 INFORMATION
                    // ------------------------------------------------------
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F9FC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFE8ECF2),
                          width: 1,
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            color: Color(0xFF197FE6),
                            size: 23,
                          ),

                          SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Available 24/7",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    color: Colors.black87,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                                SizedBox(height: 4),

                                Text(
                                  "Family-friendly entertainment whenever "
                                  "you want it.",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    color: Colors.black54,
                                    fontSize: 12,
                                    height: 1.4,
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
            ),
          ],
        ),
      ),
    );
  }
}
