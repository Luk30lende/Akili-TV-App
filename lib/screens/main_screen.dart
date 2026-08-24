import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'live_screen.dart';
import 'about_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ============================================================
      // SCREEN CONTENT
      // ============================================================
      body: _buildCurrentScreen(),

      // ============================================================
      // BOTTOM NAVIGATION
      // ============================================================
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFE8ECF2), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: NavigationBar(
              height: 68,
              backgroundColor: Colors.white,
              elevation: 0,
              selectedIndex: currentIndex,

              indicatorColor: const Color(0xFFEAF3FF),

              onDestinationSelected: (index) {
                setState(() {
                  currentIndex = index;
                });
              },

              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,

              destinations: const [
                // --------------------------------------------------
                // HOME
                // --------------------------------------------------
                NavigationDestination(
                  icon: Icon(Icons.home_outlined, color: Colors.black54),
                  selectedIcon: Icon(
                    Icons.home_rounded,
                    color: Color(0xFF197FE6),
                  ),
                  label: "Home",
                ),

                // --------------------------------------------------
                // LIVE
                // --------------------------------------------------
                NavigationDestination(
                  icon: Icon(Icons.live_tv_outlined, color: Colors.black54),
                  selectedIcon: Icon(
                    Icons.live_tv_rounded,
                    color: Color(0xFF197FE6),
                  ),
                  label: "Live",
                ),

                // --------------------------------------------------
                // ABOUT
                // --------------------------------------------------
                NavigationDestination(
                  icon: Icon(Icons.info_outline_rounded, color: Colors.black54),
                  selectedIcon: Icon(
                    Icons.info_rounded,
                    color: Color(0xFF197FE6),
                  ),
                  label: "About",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================================================================
  // CURRENT SCREEN
  // ================================================================

  Widget _buildCurrentScreen() {
    switch (currentIndex) {
      case 0:
        return HomeScreen(
          onWatchLive: () {
            setState(() {
              currentIndex = 1;
            });
          },
        );

      case 1:
        return LiveScreen(
          onExit: () {
            setState(() {
              currentIndex = 0;
            });
          },
        );

      case 2:
        return const AboutScreen();

      default:
        return HomeScreen(
          onWatchLive: () {
            setState(() {
              currentIndex = 1;
            });
          },
        );
    }
  }
}
