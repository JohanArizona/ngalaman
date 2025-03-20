import 'package:flutter/material.dart';

class SyaratKetentuanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Image.asset('lib/assets/back.png', height: 32),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo
            Image.asset('lib/assets/Vector.png', height: 80),
            SizedBox(height: 20),

            // Judul
            Text(
              "Syarat & Ketentuan Penggunaan Kebijakan Privasi",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8B3DFF),
              ),
            ),
            SizedBox(height: 10),

            // Sub Judul
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Syarat & Ketentuan Penggunaan",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Isi Syarat & Ketentuan
            Text(
              """1. Penerimaan Ketentuan
Dengan menggunakan aplikasi Ngalaman, pengguna setuju untuk mematuhi syarat dan ketentuan ini. Jika tidak setuju, harap tidak menggunakan aplikasi ini.

2. Penggunaan Layanan
- Ngalaman adalah aplikasi berbasis lokasi yang memungkinkan pengguna berbagi lokasi dengan teman.
- Pengguna harus berusia minimal 15 tahun atau memiliki izin dari orang tua/wali untuk menggunakan layanan ini.
- Pengguna bertanggung jawab atas keamanan akun dan tidak boleh membagikan kredensial akun kepada pihak lain.

3. Hak dan Kewajiban Pengguna
- Pengguna setuju untuk tidak menggunakan aplikasi untuk tindakan ilegal, pelecehan, atau penyalahgunaan data lokasi.
- Pengguna dapat mengatur privasi lokasi mereka dan memilih siapa saja yang dapat melihat lokasinya.

4. Penghentian Layanan
Kami berhak menangguhkan atau menghapus akun pengguna yang melanggar ketentuan tanpa pemberitahuan sebelumnya.

5. Perubahan Ketentuan
Kami dapat mengubah syarat dan ketentuan ini sewaktu-waktu. Pengguna disarankan untuk selalu memeriksa pembaruan terbaru.""",
              style: TextStyle(fontSize: 14, color: Colors.black87),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 20),

            // Sub Judul Kebijakan Privasi
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Kebijakan Privasi",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),

            // Isi Kebijakan Privasi
            Text(
              """1. Informasi yang Dikumpulkan
Kami mengumpulkan informasi berikut untuk meningkatkan pengalaman pengguna:
- Informasi akun: Nama, email, nomor telepon (jika diperlukan).
- Data lokasi: Agar pengguna dapat berbagi lokasi dengan teman.
- Data perangkat: Termasuk jenis perangkat dan sistem operasi untuk keperluan pengoptimalan layanan.

2. Cara Kami Menggunakan Informasi
- Untuk menampilkan lokasi pengguna kepada teman yang telah diberikan izin.
- Untuk meningkatkan keamanan dan kenyamanan penggunaan aplikasi.
- Untuk memberikan rekomendasi fitur dan pengalaman yang lebih personal.

3. Keamanan Data
Kami menggunakan sistem enkripsi dan perlindungan data untuk menjaga keamanan informasi pengguna.

4. Hak Pengguna
- Pengguna dapat mengubah atau menghapus akun kapan saja.
- Pengguna dapat menonaktifkan fitur berbagi lokasi jika tidak ingin membagikan lokasinya kepada orang lain.

5. Pihak Ketiga
Kami tidak menjual atau membagikan informasi pribadi pengguna kepada pihak ketiga tanpa persetujuan, kecuali jika diwajibkan oleh hukum.

6. Pembaruan Kebijakan
Kami dapat memperbarui kebijakan privasi ini sewaktu-waktu, dan pengguna disarankan untuk memeriksa pembaruan terbaru secara berkala.""",
              style: TextStyle(fontSize: 14, color: Colors.black87),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 30),

            // Tombol Tidak Setuju & Setuju
            Padding(
              padding: EdgeInsets.only(bottom: 32), // Beri jarak dari bawah
              child: SizedBox(
                width: double.infinity, // Pastikan Row tetap dalam batas layar
                child: Row(
                  mainAxisSize:
                      MainAxisSize.min, // Agar Row tidak memaksakan lebar
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Tombol tetap di tengah
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(
                            context,
                            false,
                          ); // Kirim false ke halaman Register
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          minimumSize: Size(196, 60),
                          side: BorderSide(color: Color(0xFF8B3DFF), width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Text(
                          "Saya Tidak Setuju",
                          style: TextStyle(
                            color: Color(0xFF8B3DFF),
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12), // Jarak antar tombol
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(
                            context,
                            true,
                          ); // Kirim true ke halaman Register
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF8B3DFF),
                          minimumSize: Size(196, 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Text(
                          "Saya Setuju",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
