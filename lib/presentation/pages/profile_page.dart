import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:path_provider/path_provider.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLocationShared = true;
  Position? _currentPosition;
  String _currentAddress = "Lokasi belum diketahui";
  bool _isLoading = false;
  String? _profilePhotoPath; // Store the local file path of the profile photo

  @override
  void initState() {
    super.initState();
    _checkLocationSharingStatus();
    if (_isLocationShared) {
      _getCurrentLocation();
    }
    _loadProfilePhotoPath(); // Load the profile photo path on init
  }

  // Load the profile photo path from Firestore or local storage
  Future<void> _loadProfilePhotoPath() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
      if (snapshot.exists) {
        var userData = snapshot.data() as Map<String, dynamic>;
        setState(() {
          _profilePhotoPath = userData['profilePhotoPath']; // Local file path
        });
      }
    }
  }

  Future<void> _checkLocationSharingStatus() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
      if (snapshot.exists) {
        var userData = snapshot.data() as Map<String, dynamic>;
        setState(() {
          _isLocationShared = userData['isLocationShared'] ?? true;
        });
      }
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Layanan lokasi dinonaktifkan. Mohon aktifkan layanan lokasi.',
          ),
        ),
      );
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Izin lokasi ditolak')));
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Izin lokasi ditolak secara permanen')),
      );
      return false;
    }
    return true;
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() => _currentPosition = position);
      await _getAddressFromLatLng(position);
      if (_isLocationShared) {
        _saveLocationToFirebase();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak dapat mengambil lokasi: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}';
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _saveLocationToFirebase() async {
    User? user = _auth.currentUser;
    if (user != null && _currentPosition != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
              'isLocationShared': _isLocationShared,
              'location':
                  _isLocationShared
                      ? {
                        'latitude': _currentPosition!.latitude,
                        'longitude': _currentPosition!.longitude,
                        'address': _currentAddress,
                        'updatedAt': FieldValue.serverTimestamp(),
                      }
                      : null,
            });
      } catch (e) {
        debugPrint('Error saving location: $e');
      }
    }
  }

  void _toggleLocationSharing(bool newValue) async {
    setState(() => _isLocationShared = newValue);
    if (newValue) {
      await _getCurrentLocation();
    } else {
      User? user = _auth.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'isLocationShared': false, 'location': null});
      }
      setState(() {
        _currentPosition = null;
        _currentAddress = "Lokasi tidak dibagikan";
      });
    }
  }

  Future<Map<String, dynamic>> _fetchUserData() async {
    User? user = _auth.currentUser;
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

  void _showFloatingNotification(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            content: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 10),
                Text('Profil berhasil diperbarui'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  Future<void> _logout() async {
    try {
      await _auth.signOut();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal logout: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _fetchUserData(),
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          var userData = snapshot.data ?? {};

          return DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xffD0B8F4), Colors.white],
              ),
            ),
            child: Stack(
              children: [
                SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 60, 20, 16),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage:
                              _profilePhotoPath != null &&
                                      File(_profilePhotoPath!).existsSync()
                                  ? FileImage(File(_profilePhotoPath!))
                                  : const AssetImage(
                                        'lib/assets/default_avatar.png',
                                      )
                                      as ImageProvider,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () async {
                            final result = await showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder:
                                  (context) => FractionallySizedBox(
                                    heightFactor: 0.9,
                                    child: EditProfilePage(userData: userData),
                                  ),
                            );
                            if (result == true) {
                              setState(() {});
                              _loadProfilePhotoPath(); // Reload the photo path after editing
                              _showFloatingNotification(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(
                              114,
                              42,
                              221,
                              1.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'Ubah Profil',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoSection(userData),
                        const SizedBox(height: 16),
                        _buildLocationSection(),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 20,
                  child: IconButton(
                    icon: const Icon(Icons.logout, color: Colors.black),
                    onPressed: () async {
                      await _logout();
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoSection(Map<String, dynamic> userData) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoField(
            'Nama',
            '${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}',
          ),
          _buildInfoField('Email', userData['email'] ?? ''),
        ],
      ),
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 6),
          TextFormField(
            initialValue: value,
            enabled: false,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xffD0B8F4)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.location_pin,
                color: Color.fromRGBO(114, 42, 221, 1.0),
                size: 20,
              ),
              SizedBox(width: 10),
              Text(
                'Lokasi Saya',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text('Lokasi', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(_currentAddress),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Bagikan Lokasi Saya', style: TextStyle(fontSize: 14)),
              Switch(
                value: _isLocationShared,
                onChanged: _toggleLocationSharing,
                activeColor: Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
