import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, String>> friends;

  const HomePage({super.key, required this.friends});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gambar peta full layar
          Positioned.fill(
            child: Image.asset(
              'lib/assets/openmaptiles.png',
              fit: BoxFit.cover,
            ),
          ),

          CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.only(
                  top: 40.0,
                  left: 16.0,
                  right: 16.0,
                ),
                sliver: SliverToBoxAdapter(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 10,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: AssetImage(
                                    'lib/assets/Zaki.png',
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Selamat datang!',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      'Zaki Raditya',
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {
                                // Logika untuk tombol lokasi
                              },
                              icon: Icon(
                                Icons.location_pin,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverFillRemaining(child: Container()),
            ],
          ),
          ...friends.map((friend) {
            return Positioned(
              left: _getRandomXPosition(),
              top: _getRandomYPosition(),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Color(0xFF9747FF),
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  SizedBox(height: 4),
                  Text(
                    friend['name']!,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.black,
                      // ignore: deprecated_member_use
                      backgroundColor: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // Fungsi untuk posisi acak (demo)
  double _getRandomXPosition() {
    return (DateTime.now().millisecond % 200).toDouble() + 50;
  }

  double _getRandomYPosition() {
    return (DateTime.now().microsecond % 400).toDouble() + 150;
  }
}
