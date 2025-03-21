import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main_page.dart'; // Impor untuk mengakses AddFriendPage

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final List<Map<String, String>> friends = [];

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  // Fungsi untuk mengambil daftar teman dari Firestore
  Future<void> _loadFriends() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
    if (userDoc.exists && userDoc.data()!.containsKey('friends')) {
      setState(() {
        friends.clear();
        friends.addAll(
          List<String>.from(userDoc['friends']).map(
            (email) => {
              'name': email,
              'location': 'Belum diketahui',
              'time': 'Sekarang',
            },
          ),
        );
      });
    }
  }

  // Fungsi untuk menambah teman baru
  Future<void> _addFriend(String email) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);

    await userRef.update({
      'friends': FieldValue.arrayUnion([email]),
    });

    setState(() {
      friends.add({
        'name': email,
        'location': 'Belum diketahui',
        'time': 'Sekarang',
      });
    });
  }

  // Fungsi untuk menghapus teman
  Future<void> _deleteFriend(int index) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);
    await userRef.update({
      'friends': FieldValue.arrayRemove([friends[index]['name']]),
    });

    setState(() {
      friends.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Teman:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(
                  Icons.person_add,
                  color: Color.fromRGBO(114, 42, 221, 1.0),
                ),
                onPressed: () {
                  // Navigasi ke halaman AddFriendPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => AddFriendPage(onAddFriend: _addFriend),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: friends.length,
              itemBuilder: (context, index) {
                return _friendTile(context, friends[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _friendTile(
    BuildContext context,
    Map<String, String> friend,
    int index,
  ) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Color(0xFF9747FF),
        child: Icon(Icons.person),
      ),
      title: Text(friend['name']!),
      subtitle: Text('${friend['location']} - ${friend['time']}'),
      trailing: IconButton(
        icon: const Icon(
          Icons.person_remove,
          color: Color.fromRGBO(114, 42, 221, 1.0),
        ),
        onPressed: () {
          _showDeleteConfirmationDialog(context, friend['name']!, index);
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(
    BuildContext context,
    String friendName,
    int index,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.person_remove, color: Colors.red, size: 24),
              const SizedBox(width: 8),
              Text(
                'Hapus "$friendName"?',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            'Anda tidak akan bisa lagi saling mengirim lokasi. Anda dan "$friendName" tidak akan menerima notifikasi satu sama lain.',
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteFriend(index);
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }
}
