import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'home_page.dart';
import 'education_page.dart';
import 'profile_page.dart';
import 'friends_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  List<Map<String, String>> friends = [
    {'name': 'Tiara', 'location': 'Malang, Jawa Timur', 'time': 'Sekarang'},
    {'name': 'Hani', 'location': 'Malang, Jawa Timur', 'time': 'Sekarang'},
    {'name': 'Nora', 'location': 'Malang, Jawa Timur', 'time': 'Sekarang'},
    {'name': 'Nisa', 'location': '87 km', 'time': '3 menit lalu'},
    {'name': 'Johan', 'location': 'Malang, Jawa Timur', 'time': '8 menit lalu'},
    {
      'name': 'Farel',
      'location': 'Malang, Jawa Timur',
      'time': '10 menit lalu',
    },
    {'name': 'Atif', 'location': '101 km', 'time': '15 menit lalu'},
    {'name': 'Ridwan', 'location': 'Malang, Jawa Timur', 'time': '1 jam lalu'},
    {'name': 'Haqiq', 'location': '115 km', 'time': '2 jam lalu'},
  ];

  void _showFriendsList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext bottomSheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: FriendsPage(),
        );
      },
    );
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
                  // Menggunakan LaunchMode.externalApplication untuk panggilan langsung
                  await launchUrl(
                    phoneUri,
                    mode: LaunchMode.externalApplication,
                  );
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
          _getPage(_selectedIndex),
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
                  if (index == 1) {
                    _showFriendsList(context);
                  } else {
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
      floatingActionButton: null,
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return HomePage(friends: friends);
      case 1:
        return HomePage(friends: friends);
      case 2:
        return const EducationPage();
      case 3:
        return const ProfilePage();
      default:
        return HomePage(friends: friends);
    }
  }
}

// Halaman baru untuk menambah teman
class AddFriendPage extends StatefulWidget {
  final Function(String) onAddFriend;

  const AddFriendPage({super.key, required this.onAddFriend});

  @override
  _AddFriendPageState createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _addFriend(String email) {
    if (email.isNotEmpty) {
      widget.onAddFriend(email);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan alamat email yang valid!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              Image.asset(
                'lib/assets/Vector.png',
                width: 120,
                height: 120,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.image_not_supported,
                    size: 120,
                    color: Colors.grey,
                  );
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Tambah Teman',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'Masukkan alamat email teman Anda',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(114, 42, 221, 1.0),
                    ),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _addFriend(_emailController.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(114, 42, 221, 1.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Kirim Permintaan',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
