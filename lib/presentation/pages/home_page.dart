import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  final List<Map<String, String>> friends;

  const HomePage({super.key, required this.friends});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final MapController _mapController;
  LatLng _currentLocation = LatLng(-7.9666, 112.6326); // Default ke Malang
  late List<LatLng> friendLocations;
  List<Map<String, dynamic>> crimeLocations = [];
  String? _selectedCrimeType;
  String? _selectedDangerLevel;
  LatLng? _tappedLocation;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _initializeFriendLocations();
    _getUserLocation();
    _fetchCrimeReports(); // Load existing crime reports from Firestore
  }

  void _initializeFriendLocations() {
    friendLocations = widget.friends.map((_) => _getRandomPosition()).toList();
  }

  Future<void> _getUserLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
    );

    if (mounted) {
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
      _mapController.move(_currentLocation, 15.0);
    }
  }

  Future<void> _fetchCrimeReports() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('crimeReports').get();
      setState(() {
        crimeLocations =
            snapshot.docs.map((doc) {
              var data = doc.data() as Map<String, dynamic>;
              return {
                'position': LatLng(data['latitude'], data['longitude']),
                'crimeType': data['crimeType'],
                'dangerLevel': data['dangerLevel'],
                'name': data['crimeType'], // For display purposes
              };
            }).toList();
      });
    } catch (e) {
      print('Error fetching crime reports: $e');
    }
  }

  Future<void> _saveCrimeReport(
    LatLng location,
    String crimeType,
    String dangerLevel,
  ) async {
    try {
      await FirebaseFirestore.instance.collection('crimeReports').add({
        'latitude': location.latitude,
        'longitude': location.longitude,
        'crimeType': crimeType,
        'dangerLevel': dangerLevel,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error saving crime report: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan laporan: $e')));
    }
  }

  Future<Map<String, dynamic>> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      }
    }
    return {};
  }

  void _showCrimeReportDialog(BuildContext context, LatLng tappedLocation) {
    _tappedLocation = tappedLocation;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Memungkinkan scroll penuh
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext bottomSheetContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: EdgeInsets.fromLTRB(
                24.0,
                24.0,
                24.0,
                MediaQuery.of(context).viewInsets.bottom +
                    24.0, // Menghindari keyboard
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Laporkan Kriminalitas?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 16), // Dikurangi dari 24
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCrimeOption(
                          icon: Icons.motorcycle,
                          label: 'Begel',
                          isSelected: _selectedCrimeType == 'Begel',
                          onTap:
                              () => setModalState(
                                () => _selectedCrimeType = 'Begel',
                              ),
                        ),
                        _buildCrimeOption(
                          icon: Icons.person,
                          label: 'Jambret',
                          isSelected: _selectedCrimeType == 'Jambret',
                          onTap:
                              () => setModalState(
                                () => _selectedCrimeType = 'Jambret',
                              ),
                        ),
                        _buildCrimeOption(
                          icon: Icons.pan_tool,
                          label: 'Asuila',
                          isSelected: _selectedCrimeType == 'Asuila',
                          onTap:
                              () => setModalState(
                                () => _selectedCrimeType = 'Asuila',
                              ),
                        ),
                        _buildCrimeOption(
                          icon: Icons.more_horiz,
                          label: 'Lain-Lain',
                          isSelected: _selectedCrimeType == 'Lain-Lain',
                          onTap:
                              () => setModalState(
                                () => _selectedCrimeType = 'Lain-Lain',
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Tingkat Bahaya',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildDangerLevelOption(
                          icon: Icons.warning,
                          label: 'Tinggi',
                          color: Colors.red,
                          isSelected: _selectedDangerLevel == 'Tinggi',
                          onTap:
                              () => setModalState(
                                () => _selectedDangerLevel = 'Tinggi',
                              ),
                        ),
                        const SizedBox(width: 40),
                        _buildDangerLevelOption(
                          icon: Icons.warning,
                          label: 'Sedang',
                          color: Colors.yellow,
                          isSelected: _selectedDangerLevel == 'Sedang',
                          onTap:
                              () => setModalState(
                                () => _selectedDangerLevel = 'Sedang',
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.of(bottomSheetContext).pop();
                              setState(() {
                                _selectedCrimeType = null;
                                _selectedDangerLevel = null;
                                _tappedLocation = null;
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.grey),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 40,
                              ),
                            ),
                            child: const Text(
                              'Batal',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_selectedCrimeType != null &&
                                  _selectedDangerLevel != null &&
                                  _tappedLocation != null) {
                                await _saveCrimeReport(
                                  _tappedLocation!,
                                  _selectedCrimeType!,
                                  _selectedDangerLevel!,
                                );
                                setState(() {
                                  crimeLocations.add({
                                    'position': _tappedLocation!,
                                    'crimeType': _selectedCrimeType!,
                                    'dangerLevel': _selectedDangerLevel!,
                                    'name': _selectedCrimeType!,
                                  });
                                  _selectedCrimeType = null;
                                  _selectedDangerLevel = null;
                                  _tappedLocation = null;
                                });
                                Navigator.of(bottomSheetContext).pop();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Pilih jenis kriminalitas dan tingkat bahaya!',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF9747FF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 40,
                              ),
                            ),
                            child: const Text(
                              'Laporkan',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCrimeOption({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? const Color(0xFF9747FF) : Colors.grey[200],
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : Colors.black,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? const Color(0xFF9747FF) : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDangerLevelOption({
    required IconData icon,
    required String label,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? color.withOpacity(0.2) : Colors.grey[200],
            ),
            child: Icon(
              icon,
              color: isSelected ? color : Colors.black,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? color : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLocation,
              initialZoom: 14.0,
              onTap: (tapPosition, point) {
                _showCrimeReportDialog(context, point);
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  // Marker untuk lokasi pengguna
                  Marker(
                    point: _currentLocation,
                    width: 80.0,
                    height: 80.0,
                    child: const Icon(
                      Icons.my_location,
                      color: Colors.blue,
                      size: 80,
                    ),
                  ),
                  // Marker untuk teman (dikecilkan lagi)
                  for (int i = 0; i < widget.friends.length; i++)
                    Marker(
                      point: friendLocations[i],
                      width: 60.0, // Dikecilkan dari 80.0
                      height: 50.0, // Dikecilkan dari 70.0
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircleAvatar(
                            radius: 15, // Dikecilkan dari 25
                            backgroundColor: Color(0xFF9747FF),
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 20, // Dikecilkan dari 30
                            ),
                          ),
                          const SizedBox(height: 2), // Jarak lebih kecil
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4, // Dikecilkan dari 6
                              vertical: 2, // Dikecilkan dari 3
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              widget.friends[i]['name']!,
                              style: const TextStyle(
                                fontSize: 10, // Dikecilkan dari 14
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  // Marker untuk lokasi kriminalitas
                  for (var crimeLocation in crimeLocations)
                    Marker(
                      point: crimeLocation['position'],
                      width: 150.0,
                      height: 120.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.warning,
                            color:
                                crimeLocation['dangerLevel'] == 'Tinggi'
                                    ? Colors.red
                                    : Colors.yellow,
                            size: 60,
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              crimeLocation['name'],
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 40.0,
            left: 16.0,
            right: 16.0,
            child: FutureBuilder<Map<String, dynamic>>(
              future: _fetchUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 4),
                      ],
                    ),
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasError) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 4),
                      ],
                    ),
                    child: const Text("Error fetching data"),
                  );
                }
                Map<String, dynamic> userData = snapshot.data ?? {};
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 4),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 20,
                            backgroundImage: AssetImage('lib/assets/Zaki.png'),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Selamat datang!",
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                "${userData['firstName'] ?? 'Tidak ada'} ${userData['lastName'] ?? 'data'}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: _getUserLocation,
                        icon: const Icon(
                          Icons.location_pin,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  LatLng _getRandomPosition() {
    return LatLng(
      _currentLocation.latitude +
          (0.005 * (DateTime.now().second % 2 == 0 ? 1 : -1)),
      _currentLocation.longitude +
          (0.005 * (DateTime.now().millisecond % 2 == 0 ? 1 : -1)),
    );
  }
}
