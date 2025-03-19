// File: splash_screen.dart
import 'package:flutter/material.dart';
import 'package:ngalaman/presentation/pages/onboarding_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeLogoAnimation;
  late Animation<double> _scaleLogoAnimation;
  late Animation<Alignment> _alignmentAnimation;
  late Animation<double> _fadeTextAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    // Animasi fade in untuk logo di tengah
    _fadeLogoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    // Animasi mengecilkan logo dari besar ke kecil
    _scaleLogoAnimation = Tween<double>(begin: 1.5, end: 0.6).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.7, curve: Curves.easeInOut),
      ),
    );

    // Animasi perubahan posisi dari tengah ke kiri
    _alignmentAnimation = Tween<Alignment>(
      begin: Alignment.center,
      end: Alignment(-0.6, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.7, curve: Curves.easeInOut),
      ),
    );

    // Animasi fade in untuk teks
    _fadeTextAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 0.9, curve: Curves.easeIn),
      ),
    );

    _controller.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const OnboardingPage(),
            ),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF8B3DFF),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              // Logo yang muncul di tengah, lalu mengecil dan bergeser ke kiri
              Positioned.fill(
                child: AnimatedAlign(
                  alignment: _alignmentAnimation.value,
                  duration: Duration.zero,
                  child: ScaleTransition(
                    scale: _scaleLogoAnimation,
                    child: FadeTransition(
                      opacity: _fadeLogoAnimation,
                      child: Image.asset(
                        'lib/assets/logo_putih.png',
                        width: 120,
                        height: 120,
                      ),
                    ),
                  ),
                ),
              ),
              
              // Tulisan Ngalaman
            if (_fadeTextAnimation.value > 0)
              Positioned(
                left: MediaQuery.of(context).size.width * 0.39, 
                top: MediaQuery.of(context).size.height * 0.48, 
                child: FadeTransition(
                  opacity: _fadeTextAnimation,
                  child: Image.asset(
                    'lib/assets/nama_app.png',
                    width: 180, // Sesuaikan ukuran
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}