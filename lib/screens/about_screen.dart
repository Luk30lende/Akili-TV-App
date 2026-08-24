import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // 🔹 HEADER
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "About Akili TV",
          style: TextStyle(
            color: Color(0xFF197FE6),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // 🔹 DIVIDER
          Container(height: 1, color: const Color(0xFFEDEDED)),

          // 🔹 CONTENT
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // 🔹 ICON / LOGO BOX
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF197FE6), Color(0xFF074CFF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF197FE6).withOpacity(0.4),
                          blurRadius: 25,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 🔥 CINEMATIC BRAND TEXT (UPDATED)
                  const Column(
                    children: [
                      Text(
                        "Welcome To Akili TV",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      SizedBox(height: 12),

                      Text(
                        "More Fun, More Learning,\nFor Everyone!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),

                      SizedBox(height: 25),

                      Text(
                        "Kenya's leading family TV station, Akili TV, brings fun, safe, and educational entertainment straight to your home. Formerly Akili Kids! the channel has evolved into Akili TV to better serve families across the country. Enjoy top-rated kids’ shows and family-friendly programs everyone can watch together.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.6,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // 🔹 FEATURE CARD 1
                  _buildFeatureCard(
                    icon: Icons.family_restroom,
                    title: "Family First Entertainment",
                    description:
                        "A safe viewing space designed for children, teens, and parents to enjoy together. Every show is curated to be fun, educational, and family-friendly.",
                  ),

                  const SizedBox(height: 20),

                  // 🔹 FEATURE CARD 2
                  _buildFeatureCard(
                    icon: Icons.ondemand_video,
                    title: "Stories That Inspire",
                    description:
                        "From animated adventures to real-life African stories, Akili TV delivers content that entertains while encouraging creativity, learning, and imagination.",
                  ),

                  const SizedBox(height: 20),

                  // 🔹 FEATURE CARD 3
                  _buildFeatureCard(
                    icon: Icons.public,
                    title: "Made for Africa, Loved Globally",
                    description:
                        "A growing platform showcasing African culture, education, and storytelling while connecting families across the continent.",
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 FEATURE CARD WIDGET
  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF197FE6)),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                    height: 1.4,
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
