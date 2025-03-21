import 'package:flutter/material.dart';
import 'package:ngalaman/presentation/pages/register_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingContent> _contents = [
    OnboardingContent(
      image: 'lib/assets/onboard_1.png',
      title: 'Lokasi Real-Time di Ujung Jari Anda',
      description:
          'Dapatkan pembaruan lokasi real-time yang akurat dari kontak terpercaya Anda. Pastikan keselamatan dan respons cepat dalam situasi darurat dengan pelacakan akurasi tinggi.',
    ),
    OnboardingContent(
      image: 'lib/assets/onboard_2.png',
      title: 'Tetap Terhubung dengan Orang Terdekat',
      description:
          'Lacak lokasi real-time teman dan keluarga untuk meningkatkan keamanan. Pastikan mereka tetap dalam jangkauan dan terima notifikasi saat diperlukan.',
    ),
    OnboardingContent(
      image: 'lib/assets/onboard_3.png',
      title: 'Kami Menghargai Privasi Anda',
      description:
          'Akses lokasi yang fleksibel dan aman. Kendalikan siapa yang dapat melihat lokasimu dan pastikan hanya kontak terpercaya yang memiliki akses saat diperlukan.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Image.asset(
                'lib/assets/Vector.png',
                width: 32,
                height: 39,
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _contents.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: Image.asset(
                            _contents[index].image,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          _contents[index].title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8B3DFF),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          _contents[index].description,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _contents.length,
                (index) => Container(
                  margin: const EdgeInsets.only(right: 5),
                  height: 10,
                  width: _currentPage == index ? 25 : 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color:
                        _currentPage == index
                            ? const Color(0xFF8B3DFF)
                            : Colors.grey.shade300,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage == _contents.length - 1) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B3DFF),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    _currentPage == _contents.length - 1
                        ? 'Mulai'
                        : 'Selanjutnya',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class OnboardingContent {
  final String image;
  final String title;
  final String description;

  OnboardingContent({
    required this.image,
    required this.title,
    required this.description,
  });
}
