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

  // ============================================================
  // STREAM STATE
  // ============================================================

  bool isLoading = true;
  bool hasError = false;
  bool isBuffering = false;
  bool isReconnecting = false;

  int retryCount = 0;

  static const int maxAutomaticRetries = 3;

  final String streamUrl =
      'https://m6.livecdn.io/akilikids.co.ke/akilikids.smil/chunklist_w88071026_b2528000_slke.m3u8';

  // ============================================================
  // INITIALIZE
  // ============================================================

  @override
  void initState() {
    super.initState();

    initializeVideo();
  }

  // ============================================================
  // INITIALIZE VIDEO
  // ============================================================

  Future<void> initializeVideo() async {
    // ------------------------------------------------------------
    // WEB
    // ------------------------------------------------------------

    if (kIsWeb) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        hasError = false;
      });

      openStream();
      return;
    }

    // ------------------------------------------------------------
    // RESET UI STATE
    // ------------------------------------------------------------

    if (mounted) {
      setState(() {
        isLoading = true;
        hasError = false;
        isBuffering = false;
      });
    }

    // ------------------------------------------------------------
    // DISPOSE PREVIOUS CONTROLLERS
    // ------------------------------------------------------------

    _disposeControllers();

    try {
      debugPrint("Initializing live stream...");

      // ----------------------------------------------------------
      // CREATE VIDEO CONTROLLER
      // ----------------------------------------------------------

      final controller = VideoPlayerController.networkUrl(Uri.parse(streamUrl));

      videoPlayerController = controller;

      // ----------------------------------------------------------
      // LISTEN FOR PLAYBACK CHANGES
      // ----------------------------------------------------------

      controller.addListener(_videoListener);

      // ----------------------------------------------------------
      // INITIALIZE STREAM
      // ----------------------------------------------------------

      await controller.initialize();

      // ----------------------------------------------------------
      // CHECK IF WIDGET STILL EXISTS
      // ----------------------------------------------------------

      if (!mounted) {
        controller.removeListener(_videoListener);
        controller.dispose();
        return;
      }

      // ----------------------------------------------------------
      // CREATE CHEWIE CONTROLLER
      // ----------------------------------------------------------

      chewieController = ChewieController(
        videoPlayerController: controller,
        autoPlay: true,
        looping: true,
        showControls: true,

        // Keep the built-in fullscreen button.
        allowFullScreen: true,

        // Allow mute button.
        allowMuting: true,

        // Tell Chewie this is a live stream.
        isLive: true,
      );

      // ----------------------------------------------------------
      // RESET RETRY COUNT AFTER SUCCESSFUL CONNECTION
      // ----------------------------------------------------------

      retryCount = 0;

      setState(() {
        isLoading = false;
        hasError = false;
        isBuffering = false;
        isReconnecting = false;
      });

      debugPrint("Video initialized successfully");
    } catch (error) {
      debugPrint("Video initialization error: $error");

      _disposeControllers();

      if (!mounted) return;

      setState(() {
        isLoading = false;
        hasError = true;
        isBuffering = false;
        isReconnecting = false;
      });
    }
  }

  // ============================================================
  // VIDEO LISTENER
  // ============================================================

  void _videoListener() {
    final controller = videoPlayerController;

    if (controller == null || !mounted) return;

    final value = controller.value;

    // ------------------------------------------------------------
    // BUFFERING
    // ------------------------------------------------------------

    if (value.isBuffering != isBuffering) {
      setState(() {
        isBuffering = value.isBuffering;
      });

      if (value.isBuffering) {
        debugPrint("Live stream is buffering...");
      } else {
        debugPrint("Live stream buffering ended.");
      }
    }

    // ------------------------------------------------------------
    // PLAYBACK ERROR
    // ------------------------------------------------------------

    if (value.hasError) {
      debugPrint("Live stream playback error: ${value.errorDescription}");

      _handleStreamError();
    }
  }

  // ============================================================
  // HANDLE STREAM ERROR
  // ============================================================

  void _handleStreamError() {
    if (!mounted) return;

    // Prevent multiple listeners from triggering
    // multiple reconnection attempts simultaneously.
    if (isReconnecting || hasError) return;

    debugPrint("Live stream disconnected.");

    setState(() {
      isReconnecting = true;
      isBuffering = false;
    });

    _attemptAutomaticReconnect();
  }

  // ============================================================
  // AUTOMATIC RECONNECT
  // ============================================================

  Future<void> _attemptAutomaticReconnect() async {
    // ------------------------------------------------------------
    // MAX RETRIES REACHED
    // ------------------------------------------------------------

    if (retryCount >= maxAutomaticRetries) {
      debugPrint("Maximum automatic retry attempts reached.");

      if (!mounted) return;

      setState(() {
        isReconnecting = false;
        isLoading = false;
        hasError = true;
      });

      return;
    }

    retryCount++;

    debugPrint(
      "Automatic reconnect attempt "
      "$retryCount/$maxAutomaticRetries",
    );

    // ------------------------------------------------------------
    // WAIT BEFORE RETRYING
    // ------------------------------------------------------------

    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // ------------------------------------------------------------
    // RECONNECT
    // ------------------------------------------------------------

    await initializeVideo();

    if (!mounted) return;

    // ------------------------------------------------------------
    // SUCCESS
    // ------------------------------------------------------------

    if (!hasError) {
      debugPrint("Live stream reconnected successfully.");

      setState(() {
        isReconnecting = false;
      });

      return;
    }

    // ------------------------------------------------------------
    // FAILURE
    // ------------------------------------------------------------

    if (retryCount < maxAutomaticRetries) {
      setState(() {
        isReconnecting = true;
      });

      await _attemptAutomaticReconnect();
    } else {
      setState(() {
        isReconnecting = false;
        hasError = true;
        isLoading = false;
      });
    }
  }

  // ============================================================
  // MANUAL RETRY
  // ============================================================

  void retryStream() {
    debugPrint("Manual stream retry requested.");

    retryCount = 0;

    initializeVideo();
  }

  // ============================================================
  // OPEN STREAM ON WEB
  // ============================================================

  Future<void> openStream() async {
    final Uri url = Uri.parse(streamUrl);

    try {
      await launchUrl(url, mode: LaunchMode.platformDefault);
    } catch (error) {
      debugPrint("Could not open stream: $error");
    }
  }

  // ============================================================
  // DISPOSE CONTROLLERS
  // ============================================================

  void _disposeControllers() {
    // ------------------------------------------------------------
    // CHEWIE
    // ------------------------------------------------------------

    chewieController?.dispose();
    chewieController = null;

    // ------------------------------------------------------------
    // VIDEO PLAYER
    // ------------------------------------------------------------

    final controller = videoPlayerController;

    if (controller != null) {
      controller.removeListener(_videoListener);
      controller.dispose();
    }

    videoPlayerController = null;
  }

  // ============================================================
  // DISPOSE SCREEN
  // ============================================================

  @override
  void dispose() {
    _disposeControllers();

    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

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
            // VIDEO PLAYER SECTION
            // ============================================================
            AspectRatio(
              aspectRatio: 16 / 9,

              child: Stack(
                children: [
                  // ======================================================
                  // LOADING STATE
                  // ======================================================
                  if (isLoading)
                    Container(
                      width: double.infinity,
                      color: Colors.black,

                      child: const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 32,
                              height: 32,

                              child: CircularProgressIndicator(
                                color: Colors.red,
                                strokeWidth: 3,
                              ),
                            ),

                            SizedBox(height: 14),

                            Text(
                              "Connecting To Live Stream...",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  // ======================================================
                  // ERROR STATE
                  // ======================================================
                  else if (hasError)
                    Container(
                      width: double.infinity,
                      color: const Color(0xFF111111),

                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),

                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // ERROR ICON
                              Container(
                                width: 42,
                                height: 42,

                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),

                                child: const Icon(
                                  Icons.wifi_off_rounded,
                                  color: Colors.red,
                                  size: 22,
                                ),
                              ),

                              const SizedBox(height: 7),

                              // ERROR TITLE
                              const Text(
                                "Unable To Load The Live Stream",
                                textAlign: TextAlign.center,

                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              const SizedBox(height: 4),

                              // ERROR DESCRIPTION
                              const Text(
                                "The Live Stream Is Temporarily Unavailable.",
                                textAlign: TextAlign.center,

                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 11,
                                  height: 1.2,
                                ),
                              ),

                              const SizedBox(height: 8),

                              // RETRY BUTTON
                              SizedBox(
                                height: 34,

                                child: ElevatedButton.icon(
                                  onPressed: retryStream,

                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,

                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 6,
                                    ),

                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),

                                  icon: const Icon(
                                    Icons.refresh_rounded,
                                    size: 16,
                                  ),

                                  label: const Text(
                                    "Try Again",

                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  // ======================================================
                  // WEB STATE
                  // ======================================================
                  else if (kIsWeb)
                    Container(
                      width: double.infinity,
                      color: Colors.black,

                      child: const Center(
                        child: Text(
                          "Opening Stream...",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  // ======================================================
                  // VIDEO
                  // ======================================================
                  else if (chewieController != null &&
                      videoPlayerController != null &&
                      videoPlayerController!.value.isInitialized)
                    Chewie(controller: chewieController!)
                  // ======================================================
                  // SAFETY FALLBACK
                  // ======================================================
                  else
                    Container(
                      width: double.infinity,
                      color: Colors.black,

                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.red),
                      ),
                    ),

                  // ============================================================
                  // BACK BUTTON
                  // ============================================================
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

                  // ============================================================
                  // LIVE BADGE
                  // ============================================================
                  if (!isLoading && !hasError && !kIsWeb && !isReconnecting)
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

                  // ============================================================
                  // BUFFERING / RECONNECTING OVERLAY
                  // ============================================================
                  if (isBuffering || isReconnecting)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.45),

                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 14,
                            ),

                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.78),
                              borderRadius: BorderRadius.circular(14),
                            ),

                            child: Row(
                              mainAxisSize: MainAxisSize.min,

                              children: [
                                const SizedBox(
                                  width: 22,
                                  height: 22,

                                  child: CircularProgressIndicator(
                                    color: Colors.red,
                                    strokeWidth: 2.5,
                                  ),
                                ),

                                const SizedBox(width: 12),

                                Text(
                                  isReconnecting
                                      ? "Reconnecting..."
                                      : "Buffering...",

                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Inter',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ============================================================
            // CONTENT SECTION
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
                      "Streaming 24/7 Edutainment Content "
                      "For The Whole Family.",

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
                                  "Family-friendly entertainment "
                                  "whenever you want it.",

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
