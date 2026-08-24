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

      // videoPlayerController!.initialize().then((_) {
      //   chewieController = ChewieController(
      //     videoPlayerController: videoPlayerController!,
      //     autoPlay: true,
      //     looping: true,
      //     showControls: true,

      //     // ✅ ENABLE BUILT-IN FULLSCREEN (IMPORTANT)
      //     allowFullScreen: true,
      //     allowMuting: true,
      //   );

      //   setState(() {});
      // });
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
      // backgroundColor: const Color(0xFF0E0E0E),
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔴 VIDEO SECTION
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                children: [
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

                  // 🔙 BACK BUTTON
                  Positioned(
                    top: 10,
                    left: 10,
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withOpacity(0.5),
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

                  // 🔴 LIVE BADGE
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "LIVE",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 📺 CONTENT SECTION
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const Text(
                    //   "Akili TV Live",
                    //   style: TextStyle(
                    //     color: Colors.white,
                    //     fontSize: 26,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    const Text(
                      "Akili TV Live",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // const Text(
                    //   "Streaming 24/7 edutainment content for the whole family!",
                    //   style: TextStyle(color: Colors.white70, fontSize: 14),
                    // ),
                    const Text(
                      "Streaming 24/7 edutainment content for the whole family!",
                      style: TextStyle(color: Colors.black87, fontSize: 14),
                    ),

                    const SizedBox(height: 20),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        // color: Colors.white.withOpacity(0.05),
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.circle, color: Colors.red, size: 10),
                          SizedBox(width: 8),
                          // Text(
                          //   "Currently Streaming Live",
                          //   style: TextStyle(color: Colors.white70),
                          // ),
                          Text(
                            "Currently Streaming Live",
                            style: TextStyle(color: Colors.black87),
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
