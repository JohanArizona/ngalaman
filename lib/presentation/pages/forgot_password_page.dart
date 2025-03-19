import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../blocs/auth_bloc.dart';

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Image.asset('lib/assets/back.png', height: 32), // Ganti dengan gambar custom
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
      ),

body: SingleChildScrollView(
  child: Padding(
    padding: const EdgeInsets.all(24.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset('lib/assets/Vector.png'),
        SizedBox(height: 16),
        Text(
          "Lupa Kata Sandi?",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 30),
        Text(
          "Masukkan email Anda untuk mendapatkan tautan reset password.",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        SizedBox(height: 24),
        SizedBox(
          width: 408,
          height: 60,
          child: TextField(
            controller: emailController,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              labelText: "Alamat Email",
              labelStyle: GoogleFonts.poppins(color: Colors.grey.shade700),
              prefixIcon: Icon(Icons.email, color: Colors.grey.shade600),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
        ),
        SizedBox(height: 67),
        BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthPasswordResetSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Email reset password telah dikirim")),
              );
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error: ${state.message}")),
              );
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return Center(child: CircularProgressIndicator());
            }
            return SizedBox(
              width: 408,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  final email = emailController.text;
                  context.read<AuthBloc>().add(ForgotPasswordEvent(email: email));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF8B3DFF),
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  "Kirim Link Reset Password",
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            );
          },
        ),
      ],
    ),
  ),
),

    );
  }
}
