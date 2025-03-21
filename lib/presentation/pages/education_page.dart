import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// Model untuk video
class VideoModel {
  final String id;
  final String title;
  final String thumbnail;
  final String duration;
  final String videoId;
  final String creator;
  final String views;
  final String category;

  VideoModel({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.duration,
    required this.videoId,
    required this.creator,
    required this.views,
    required this.category,
  });
}

// Main Education Page
class EducationPage extends StatefulWidget {
  const EducationPage({Key? key}) : super(key: key);

  @override
  State<EducationPage> createState() => _EducationPageState();
}

class _EducationPageState extends State<EducationPage> {
  final TextEditingController _searchController = TextEditingController();

  // Data video lengkap
  final List<VideoModel> allVideos = [
    // Featured videos
    VideoModel(
      id: '1',
      title: 'Self-Defense untuk Pemula: Lindungi Diri dalam Situasi Darurat!',
      thumbnail: 'lib/assets/vid_1.png',
      duration: '02:51',
      videoId: 'A6SBRY_rLu4',
      creator: 'Chuai Lie Fei',
      views: '2.1 Jt tayangan',
      category: 'Teknik Dasar',
    ),
    VideoModel(
      id: '2',
      title: 'Hindari Bahaya! 5 Cara Mencegah Serangan di Tempat Umum',
      thumbnail: 'lib/assets/vid_2.png',
      duration: '03:15',
      videoId: 'AI5DQ4H4Y3Y',
      creator: 'Chuai Lie Fei',
      views: '2.1 Jt tayangan',
      category: 'Pencegahan',
    ),

    // Recommended videos
    VideoModel(
      id: '3',
      title: 'Teknik Dasar Karate',
      thumbnail: 'lib/assets/vid_3.png',
      duration: '03:37',
      videoId: '6XK0Wj7gnsM',
      creator: 'Chuai Lie Fei',
      views: '2.1 Jt tayangan',
      category: 'Teknik Dasar',
    ),
    VideoModel(
      id: '4',
      title: 'Teknik Siku dan Lutut dalam Muaythai',
      thumbnail: 'lib/assets/vid_4.png',
      duration: '03:20',
      videoId: '0qW93KmT4O8',
      creator: 'Chuai Lie Fei',
      views: '2.1 Jt tayangan',
      category: 'Teknik Dasar',
    ),
    VideoModel(
      id: '5',
      title: 'Tips Menghindari Kejahatan',
      thumbnail: 'lib/assets/vid_5.png',
      duration: '03:21',
      videoId: 'TjjHjb_Ve10',
      creator: 'Chuai Lie Fei',
      views: '2.1 Jt tayangan',
      category: 'Pencegahan',
    ),
    VideoModel(
      id: '6',
      title: '3 Jurus Karate Untuk Pemula',
      thumbnail: 'lib/assets/vid_6.png',
      duration: '04:10',
      videoId: 'M4_8PoRQP8w',
      creator: 'Chuai Lie Fei',
      views: '2.1 Jt tayangan',
      category: 'Teknik Dasar',
    ),
    VideoModel(
      id: '7',
      title: '5 Teknik Silat Yang Wajib Kamu Kuasai!',
      thumbnail: 'lib/assets/vid_7.png',
      duration: '03:54',
      videoId: 'ERMZRMqQmVI',
      creator: 'Chuai Lie Fei',
      views: '2.1 Jt tayangan',
      category: 'Teknik Dasar',
    ),
    VideoModel(
      id: '8',
      title: '5 Gerakan Silat Untuk Melindungi Diri',
      thumbnail: 'lib/assets/vid_8.png',
      duration: '02:57',
      videoId: 'Ldse4c_6feE',
      creator: 'Chuai Lie Fei',
      views: '2.1 Jt tayangan',
      category: 'Teknik Dasar',
    ),
    VideoModel(
      id: '9',
      title: '3 Langkah Aman Jika Merasa Dibuntuti',
      thumbnail: 'lib/assets/vid_9.png',
      duration: '02:58',
      videoId: '9Tuyy9d2u6o',
      creator: 'Chuai Lie Fei',
      views: '2.1 Jt tayangan',
      category: 'Pencegahan',
    ),
    VideoModel(
      id: '10',
      title: 'Cara Tetap Aman Saat Sendirian',
      thumbnail: 'lib/assets/vid_10.png',
      duration: '05:20',
      videoId: 'ILe2Pk73Yhg',
      creator: 'Chuai Lie Fei',
      views: '2.1 Jt tayangan',
      category: 'Pencegahan',
    ),
    VideoModel(
      id: '11',
      title: 'Perhatikan Sekitar! Tanda Bahaya',
      thumbnail: 'lib/assets/vid_11.png',
      duration: '04:39',
      videoId: 'hn9meBr7V7A',
      creator: 'Chuai Lie Fei',
      views: '2.1 Jt tayangan',
      category: 'Pencegahan',
    ),
  ];

  int _selectedIndex = 2; // Indeks untuk tab "Edukasi"
  final List<String> _categories = ['Semua', 'Teknik Dasar', 'Pencegahan'];
  int _selectedCategoryIndex = 0;

  // Mendapatkan video berdasarkan kategori
  List<VideoModel> _getVideosByCategory(String category) {
    if (category == 'Semua') {
      return allVideos;
    } else {
      return allVideos.where((video) => video.category == category).toList();
    }
  }

  // Mendapatkan featured videos (2 video pertama)
  List<VideoModel> get featuredVideos {
    final videos = _getVideosByCategory(_categories[_selectedCategoryIndex]);
    return videos.take(2).toList();
  }

  // Mendapatkan recommended videos (video lainnya)
  List<VideoModel> get recommendedVideos {
    final videos = _getVideosByCategory(_categories[_selectedCategoryIndex]);
    return videos.length > 2 ? videos.sublist(2) : [];
  }

  void _showSosConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Color(0xFF9747FF),
                size: 30,
              ),
              SizedBox(width: 10),
              Text(
                'Konfirmasi SOS',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          content: Text(
            'Apakah Anda yakin ingin memanggil?',
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'Batal',
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                try {
                  final Uri phoneUri = Uri(scheme: 'tel', path: '112');
                  if (await canLaunchUrl(phoneUri)) {
                    await launchUrl(phoneUri);
                  } else {
                    throw 'Tidak dapat membuka aplikasi telepon';
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text(
                'Ya',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Color(0xFF9747FF),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 16),
                    _buildSearchBar(),
                    const SizedBox(height: 16),
                    _buildCategories(),
                    const SizedBox(height: 16),
                    _buildFeaturedVideos(),
                    const SizedBox(height: 24),
                    _buildRecommendedVideos(),
                    const SizedBox(height: 100), // Space for bottom navigation
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 16.0,
            right: 16.0,
            bottom: 16.0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home, size: 32),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.people, size: 32),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.my_library_books_rounded, size: 32),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person, size: 32),
                    label: '',
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: const Color(0xFF9747FF),
                unselectedItemColor: Colors.grey,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                type: BottomNavigationBarType.fixed,
                onTap: (index) {
                  if (index != _selectedIndex) {
                    // Navigasi ke halaman lain jika diperlukan
                    // Untuk saat ini, kita hanya update index
                    setState(() {
                      _selectedIndex = index;
                    });
                  }
                },
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 35.0,
            bottom: 70.0,
            child: GestureDetector(
              onTap: () {
                _showSosConfirmationDialog(context);
              },
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.phone, color: Colors.white, size: 18),
                    SizedBox(width: 6),
                    Text(
                      'SOS',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Edukasi',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, right: 5),
          child: Image.asset('lib/assets/Vector.png', width: 69, height: 81),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF722ADD)),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Cari video edukasi...',
          prefixIcon: const Icon(Icons.search, color: Color(0xFF722ADD)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategoryIndex = index;
              });

              // Jika memilih kategori spesifik, navigasi ke halaman kategori
              if (index > 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => CategoryPage(
                          category: _categories[index],
                          videos: _getVideosByCategory(_categories[index]),
                        ),
                  ),
                );
              }
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color:
                    _selectedCategoryIndex == index
                        ? Colors.deepPurple
                        : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.deepPurple),
              ),
              child: Center(
                child: Text(
                  _categories[index],
                  style: TextStyle(
                    color:
                        _selectedCategoryIndex == index
                            ? Colors.white
                            : Colors.deepPurple,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedVideos() {
    return featuredVideos.isEmpty
        ? const SizedBox()
        : SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: featuredVideos.length,
            itemBuilder: (context, index) {
              final video = featuredVideos[index];
              return GestureDetector(
                onTap: () {
                  _navigateToVideoPlayer(video.videoId, video.title);
                },
                child: Container(
                  width: 280,
                  margin: const EdgeInsets.only(right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              video.thumbnail,
                              width: 280,
                              height: 160,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 280,
                                  height: 160,
                                  color: Colors.grey.shade300,
                                  child: const Center(
                                    child: Icon(Icons.image_not_supported),
                                  ),
                                );
                              },
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                video.duration,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.7),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.play_arrow,
                                  color: Colors.deepPurple,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        video.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
  }

  Widget _buildRecommendedVideos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rekomendasi Video',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        recommendedVideos.isEmpty
            ? const Center(child: Text('Tidak ada video yang tersedia'))
            : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recommendedVideos.length,
              itemBuilder: (context, index) {
                final video = recommendedVideos[index];
                return GestureDetector(
                  onTap: () {
                    _navigateToVideoPlayer(video.videoId, video.title);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                video.thumbnail,
                                width: 140,
                                height: 90,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 140,
                                    height: 90,
                                    color: Colors.grey.shade300,
                                    child: const Center(
                                      child: Icon(Icons.image_not_supported),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Positioned(
                              bottom: 4,
                              right: 4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  video.duration,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.7),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.play_arrow,
                                    color: Colors.deepPurple,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                video.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                video.creator,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Icon(
                                    Icons.visibility,
                                    size: 14,
                                    color: Colors.grey.shade700,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    video.views,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.more_vert),
                          color: Colors.grey.shade700,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      ],
    );
  }

  void _navigateToVideoPlayer(String videoId, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(videoId: videoId, title: title),
      ),
    );
  }
}

// Halaman Kategori
class CategoryPage extends StatelessWidget {
  final String category;
  final List<VideoModel> videos;

  const CategoryPage({Key? key, required this.category, required this.videos})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: videos.length,
              itemBuilder: (context, index) {
                final video = videos[index];
                return GestureDetector(
                  onTap: () {
                    _navigateToVideoPlayer(context, video.videoId, video.title);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                video.thumbnail,
                                width: 140,
                                height: 90,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 140,
                                    height: 90,
                                    color: Colors.grey.shade300,
                                    child: const Center(
                                      child: Icon(Icons.image_not_supported),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Positioned(
                              bottom: 4,
                              right: 4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  video.duration,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.7),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.play_arrow,
                                    color: Colors.deepPurple,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                video.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                video.creator,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Icon(
                                    Icons.visibility,
                                    size: 14,
                                    color: Colors.grey.shade700,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    video.views,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.more_vert),
                          color: Colors.grey.shade700,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            left: 16.0,
            right: 16.0,
            bottom: 16.0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home, size: 32),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.people, size: 32),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.my_library_books_rounded, size: 32),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person, size: 32),
                    label: '',
                  ),
                ],
                currentIndex: 2, // Indeks untuk tab "Edukasi"
                selectedItemColor: const Color(0xFF9747FF),
                unselectedItemColor: Colors.grey,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                type: BottomNavigationBarType.fixed,
                onTap: (index) {
                  if (index != 2) {
                    Navigator.pop(context); // Kembali ke MainPage
                  }
                },
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 35.0,
            bottom: 70.0,
            child: GestureDetector(
              onTap: () {
                // Panggil fungsi SOS di sini
              },
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.phone, color: Colors.white, size: 18),
                    SizedBox(width: 6),
                    Text(
                      'SOS',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToVideoPlayer(
    BuildContext context,
    String videoId,
    String title,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(videoId: videoId, title: title),
      ),
    );
  }
}

// Video Player Screen
class VideoPlayerScreen extends StatefulWidget {
  final String videoId;
  final String title;
  final String description;
  final String creator;

  const VideoPlayerScreen({
    Key? key,
    required this.videoId,
    this.title = "Teknik Dasar Karate",
    this.description =
        "Pelajari 5 teknik dasar karate efektif untuk melindungi diri dalam situasi darurat!",
    this.creator = "Chuai Lie Fei",
  }) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;

  // Sample related videos data
  final List<Map<String, dynamic>> relatedVideos = [
    {
      'title': 'Silent Choke (Tenggorokan)',
      'duration': '01 menit',
      'thumbnail': 'lib/assets/silat_techniques.jpg',
      'type': 'Tutorial',
    },
    {
      'title': 'Breaker Spot (Hidung)',
      'duration': '01 menit',
      'thumbnail': 'lib/assets/karate_beginner.jpg',
      'type': 'Tutorial',
    },
    {
      'title': 'Shock Zone (Selangkangan)',
      'duration': '01 menit',
      'thumbnail': 'lib/assets/silat_defense.jpg',
      'type': 'Tutorial',
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Color(0xFFF8F2FF),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Player
            YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.deepPurple,
              progressColors: const ProgressBarColors(
                playedColor: Colors.deepPurple,
                handleColor: Colors.deepPurpleAccent,
              ),
              onReady: () {
                print('Player is ready.');
              },
            ),

            // Video Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E0066),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.description,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),

                  // Comments Section
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Komentar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Lihat Semua Komentar',
                          style: TextStyle(color: Colors.deepPurple),
                        ),
                      ),
                    ],
                  ),

                  // Comment Input
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: 'Tambahkan komentar...',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_forward,
                            color: Colors.grey,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),

                  // Related Videos
                  const SizedBox(height: 24),
                  const Text(
                    'Video Lain',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  // Related Videos List
                  ...relatedVideos.map(
                    (video) => Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          // Thumbnail
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  video['thumbnail'],
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 70,
                                      height: 70,
                                      color: Colors.grey.shade300,
                                      child: const Center(
                                        child: Icon(Icons.image_not_supported),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Positioned.fill(
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.7),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.play_arrow,
                                      color: Colors.deepPurple,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Video Info
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  video['type'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  video['title'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      video['duration'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Play Button
                          CircleAvatar(
                            backgroundColor: Colors.deepPurple.shade100,
                            radius: 20,
                            child: const Icon(
                              Icons.play_arrow,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
