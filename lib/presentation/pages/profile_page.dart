import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLocationShared = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Position? _currentPosition;
  String _currentAddress = "Lokasi belum diketahui";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Memeriksa status berbagi lokasi dari database
    _checkLocationSharingStatus();
    // Jika lokasi diaktifkan, ambil lokasi saat ini
    if (_isLocationShared) {
      _getCurrentLocation();
    }
  }

  // Memeriksa status berbagi lokasi dari database
  Future<void> _checkLocationSharingStatus() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (snapshot.exists) {
        var userData = snapshot.data() as Map<String, dynamic>;
        setState(() {
          _isLocationShared = userData['isLocationShared'] ?? true;
        });
      }
    }
  }

  // Fungsi untuk meminta izin lokasi
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Layanan lokasi dinonaktifkan. Mohon aktifkan layanan lokasi.')));
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Izin lokasi ditolak')));
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Izin lokasi ditolak secara permanen, kami tidak dapat meminta izin')));
      return false;
    }

    return true;
  }

  // Fungsi untuk mendapatkan lokasi saat ini
  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });

    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      
      setState(() {
        _currentPosition = position;
      });
      
      // Mendapatkan alamat dari koordinat
      await _getAddressFromLatLng(_currentPosition!);
      
      // Menyimpan lokasi ke Firebase jika lokasi diaktifkan
      if (_isLocationShared) {
        _saveLocationToFirebase();
      }
    } catch (e) {
      debugPrint(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tidak dapat mengambil lokasi: ${e.toString()}')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Mendapatkan alamat dari koordinat latitude dan longitude
  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude);

      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Menyimpan status dan data lokasi ke Firebase
  Future<void> _saveLocationToFirebase() async {
    User? user = _auth.currentUser;
    if (user != null && _currentPosition != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'isLocationShared': _isLocationShared,
          'location': _isLocationShared ? {
            'latitude': _currentPosition!.latitude,
            'longitude': _currentPosition!.longitude,
            'address': _currentAddress,
            'updatedAt': FieldValue.serverTimestamp(),
          } : null,
        });
      } catch (e) {
        debugPrint('Error saving location: ${e.toString()}');
      }
    }
  }

  // Fungsi untuk toggle status berbagi lokasi
  void _toggleLocationSharing(bool newValue) async {
    setState(() {
      _isLocationShared = newValue;
    });

    if (newValue) {
      // Jika lokasi diaktifkan, ambil lokasi saat ini
      await _getCurrentLocation();
    } else {
      // Jika lokasi dinonaktifkan, hapus data lokasi dari Firebase
      User? user = _auth.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'isLocationShared': false,
          'location': null,
        });
      }
    }
  }

  // Fungsi untuk memuat data pengguna dari Firestore
  Future<Map<String, dynamic>> _fetchUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      }
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    // Kode build tetap sama seperti sebelumnya
    return Scaffold(
      body: FutureBuilder(
        future: _fetchUserData(),
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Data tidak ditemukan"));
          }

          var userData = snapshot.data!;

          return DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xffD0B8F4), Colors.white],
              ),
            ),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 16),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: userData['photoUrl'] != null
                          ? NetworkImage(userData['photoUrl'])
                          : const AssetImage('lib/assets/default_avatar.png') as ImageProvider,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(114, 42, 221, 1.0),
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
          );
        },
      ),
    );
  }

  Widget _buildInfoSection(Map<String, dynamic> userData) {
    // Kode tetap sama seperti sebelumnya
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoField(
            'Nama',
            '${userData['firstName'] ?? 'Tidak ada'} ${userData['lastName'] ?? 'data'}',
          ),
          _buildInfoField('Email', userData['email'] ?? 'Tidak ada data'),
        ],
      ),
    );
  }

  Widget _buildInfoField(String label, String value) {
    // Kode tetap sama seperti sebelumnya
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
              enabledBorder: OutlineInputBorder(
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
    // Update bagian ini untuk menampilkan alamat dan tombol refresh lokasi
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Bagikan Lokasi Saya', style: TextStyle(fontSize: 14)),
              Switch(
                value: _isLocationShared,
                onChanged: (bool newValue) {
                  _toggleLocationSharing(newValue);
                },
                activeColor: Colors.green,
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (_isLocationShared) ...[
            const Text('Alamat Saat Ini:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(_currentAddress),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentPosition != null) ...[
                  Text(
                    'Lat: ${_currentPosition!.latitude.toStringAsFixed(4)}, ' +
                    'Long: ${_currentPosition!.longitude.toStringAsFixed(4)}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _getCurrentLocation,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ))
                      : const Icon(Icons.refresh, size: 14),
                  label: Text(_isLoading ? 'Memuat...' : 'Perbarui'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(114, 42, 221, 1.0),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}