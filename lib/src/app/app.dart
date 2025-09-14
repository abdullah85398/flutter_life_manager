import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/theme.dart';
import '../features/splash/splash_screen.dart';
import 'main_navigation.dart';

class LifeManagerApp extends StatelessWidget {
  const LifeManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LifeManager',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const SplashScreen(), // Will navigate to MainNavigation after initialization
      routes: {
        '/main': (context) => const MainNavigation(),
      },
    );
  }
}

class _HomeBackdrop extends StatelessWidget {
  const _HomeBackdrop();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('LifeManager', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
      ),
      body: Stack(
        children: [
          // Artistic gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  cs.primary.withOpacity(0.12),
                  cs.tertiary.withOpacity(0.10),
                  cs.secondary.withOpacity(0.12),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}