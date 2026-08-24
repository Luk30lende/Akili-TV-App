import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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

      // ============================================================
      // HEADER
      // ============================================================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,

        title: const Text(
          "About Akili TV",
          style: TextStyle(
            fontFamily: 'Inter',
            color: Color(0xFF197FE6),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // ============================================================
      // BODY
      // ============================================================
      body: Column(
        children: [
          Container(height: 1, color: const Color(0xFFEDEDED)),

          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 40),
              child: Column(
                children: [
                  // ======================================================
                  // LOGO
                  // ======================================================
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF197FE6), Color(0xFF074CFF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF197FE6).withOpacity(0.25),
                          blurRadius: 30,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(9),
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ======================================================
                  // MAIN TITLE
                  // ======================================================
                  const Text(
                    "Welcome To Akili TV",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PublicSans',
                      fontSize: 29,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      letterSpacing: -0.8,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ======================================================
                  // TAGLINE
                  // ======================================================
                  const Text(
                    "More Fun, More Learning,\nFor Everyone!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF197FE6),
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ======================================================
                  // INTRODUCTION
                  // ======================================================
                  const Text(
                    "Kenya's leading family TV station, Akili TV, "
                    "brings fun, safe, and educational entertainment "
                    "straight to your home. Formerly Akili Kids! the "
                    "channel has evolved into Akili TV to better serve "
                    "families across the country. Enjoy top-rated kids’ "
                    "shows and family-friendly programs everyone can "
                    "watch together.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      height: 1.65,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 36),

                  // ======================================================
                  // SECTION TITLE
                  // ======================================================
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 22,
                          decoration: BoxDecoration(
                            color: const Color(0xFF197FE6),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),

                        const SizedBox(width: 10),

                        const Text(
                          "Why Akili TV?",
                          style: TextStyle(
                            fontFamily: 'PublicSans',
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ======================================================
                  // FEATURE CARD 1
                  // ======================================================
                  _buildFeatureCard(
                    icon: Icons.family_restroom_rounded,
                    title: "Family First",
                    description:
                        "A safe viewing space designed for children, "
                        "teens, and parents to enjoy together. Every "
                        "show is curated to be fun, educational, and "
                        "family-friendly.",
                  ),

                  const SizedBox(height: 14),

                  // ======================================================
                  // FEATURE CARD 2
                  // ======================================================
                  _buildFeatureCard(
                    icon: Icons.auto_awesome_rounded,
                    title: "Stories That Inspire",
                    description:
                        "From animated adventures to real-life African "
                        "stories, Akili TV delivers content that entertains "
                        "while encouraging creativity, learning, and "
                        "imagination.",
                  ),

                  const SizedBox(height: 14),

                  // ======================================================
                  // FEATURE CARD 3
                  // ======================================================
                  _buildFeatureCard(
                    icon: Icons.public_rounded,
                    title: "Made for Kenya",
                    description:
                        "A growing platform showcasing African culture, "
                        "education, and storytelling while connecting "
                        "families across the country.",
                  ),

                  const SizedBox(height: 32),

                  // ======================================================
                  // BOTTOM BRAND STATEMENT
                  // ======================================================
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF197FE6), Color(0xFF074CFF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF197FE6).withOpacity(0.20),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.play_circle_fill_rounded,
                          color: Colors.white,
                          size: 36,
                        ),

                        SizedBox(height: 12),

                        Text(
                          "More Fun. More Learning. For Everyone.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'PublicSans',
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            height: 1.3,
                          ),
                        ),

                        SizedBox(height: 8),

                        Text(
                          "Akili TV — entertainment the whole family can enjoy.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: Colors.white70,
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ======================================================
                  // COPYRIGHT / BRAND
                  // ======================================================
                  const Text(
                    "AKILI TV",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                      color: Colors.black38,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // FEATURE CARD
  // ================================================================
  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFE8ECF2), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ------------------------------------------------------------
          // ICON
          // ------------------------------------------------------------
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF3FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: const Color(0xFF197FE6), size: 23),
          ),

          const SizedBox(width: 14),

          // ------------------------------------------------------------
          // TEXT
          // ------------------------------------------------------------
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  description,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.5,
                    height: 1.5,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
