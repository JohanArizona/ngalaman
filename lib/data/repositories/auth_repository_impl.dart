import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource authDataSource;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  AuthRepositoryImpl({required this.authDataSource});

  @override
  Future<User?> login(String email, String password) async {
    return await authDataSource.signInWithEmail(email, password);
  }

  @override
  Future<User?> register(String email, String password, String firstName, String lastName) async {
    User? user = await authDataSource.registerWithEmail(email, password);
    
    if (user != null) {
      // Simpan data tambahan ke Firestore
      await firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'photoUrl': '', // Kosong dulu, bisa di-update nanti
        'friends': [], // List teman kosong dulu
        'userLocation': null, // Lokasi user bisa di-update nanti
        'savedLocations': [], // Lokasi yang ditandai
      });
    }
    return user;
  }

  @override
  Future<void> resetPassword(String email) async {
    return await authDataSource.resetPassword(email);
  }

  // Update Foto Profil
  Future<void> updatePhotoUrl(String uid, String photoUrl) async {
    await firestore.collection('users').doc(uid).update({'photoUrl': photoUrl});
  }

  // Tambah Teman
  Future<void> addFriend(String uid, String friendId) async {
    await firestore.collection('users').doc(uid).update({
      'friends': FieldValue.arrayUnion([friendId])
    });
  }

  // Simpan Lokasi User
  Future<void> updateUserLocation(String uid, double lat, double lng) async {
    await firestore.collection('users').doc(uid).update({
      'userLocation': {'latitude': lat, 'longitude': lng}
    });
  }

  // Simpan Lokasi yang Ditandai
  Future<void> addSavedLocation(String uid, double lat, double lng) async {
    await firestore.collection('users').doc(uid).update({
      'savedLocations': FieldValue.arrayUnion([
        {'latitude': lat, 'longitude': lng}
      ])
    });
  }
}
