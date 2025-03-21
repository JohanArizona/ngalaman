import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ngalaman/presentation/pages/forgot_password_page.dart';
import 'package:ngalaman/presentation/pages/syarat_dan_ketentuan_page.dart';
import 'package:ngalaman/presentation/pages/main_page.dart';
import '../blocs/auth_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isLoginMode = false;
  bool isCheckboxChecked = false;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  // Method to show a cool success popup
  void _showSuccessPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        // Automatically close the dialog and switch to login mode after 3 seconds
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.of(context).pop(); // Close the dialog
          setState(() {
            isLoginMode = true; // Switch to login mode
            _firstNameController.clear();
            _lastNameController.clear();
            _emailController.clear();
            _passwordController.clear();
            isCheckboxChecked = false;
          });
        });

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 60),
              const SizedBox(height: 16),
              Text(
                'Berhasil Mendaftar!',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF9747FF),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Akun Anda telah dibuat.\nSilakan login untuk melanjutkan.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 16),
              const CircularProgressIndicator(color: Color(0xFF9747FF)),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 80),
              Image.asset('lib/assets/Vector.png', width: 100, height: 100),
              const SizedBox(height: 10),
              Text(
                'Selamat Datang',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Silahkan pilih mode: Login atau Register',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isLoginMode = false;
                          _emailController.clear();
                          _passwordController.clear();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isLoginMode ? Colors.grey : const Color(0xFF9747FF),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Daftar'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isLoginMode = true;
                          _emailController.clear();
                          _passwordController.clear();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isLoginMode ? const Color(0xFF9747FF) : Colors.grey,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Masuk'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              if (!isLoginMode)
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _firstNameController,
                        label: 'Nama Depan',
                        prefixIcon: Icons.person_outlined,
                        hasVisibilityToggle: false,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildTextField(
                        controller: _lastNameController,
                        label: 'Nama Belakang',
                        prefixIcon: Icons.person_outlined,
                        hasVisibilityToggle: false,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _emailController,
                label: 'Email atau Nomor Telepon',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.text,
                hasVisibilityToggle: false,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _passwordController,
                label: 'Kata Sandi',
                prefixIcon: Icons.lock_outline,
                obscureText: !_isPasswordVisible,
                hasVisibilityToggle: true,
              ),
              const SizedBox(height: 10),
              if (isLoginMode)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgotPasswordPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Lupa Password?",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
              if (!isLoginMode) const SizedBox(height: 10),
              if (!isLoginMode)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: isCheckboxChecked,
                      onChanged: (value) {
                        setState(() {
                          isCheckboxChecked = value!;
                        });
                      },
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                          children: [
                            const TextSpan(
                              text:
                                  'Dengan melanjutkan ini, Anda menyetujui terhadap ',
                            ),
                            TextSpan(
                              text:
                                  'Syarat & Ketentuan Penggunaan dan Kebijakan Privasi',
                              style: const TextStyle(
                                color: Color(0xFF9747FF),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  SyaratKetentuanPage(),
                                        ),
                                      );

                                      if (result != null) {
                                        setState(() {
                                          isCheckboxChecked = result;
                                        });
                                      }
                                    },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 30),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    if (isLoginMode) {
                      // If in login mode, navigate to MainPage
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Berhasil! Login berhasil"),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainPage(),
                        ),
                      );
                    } else {
                      // If in register mode, show success popup and switch to login
                      _showSuccessPopup(context);
                    }
                  } else if (state is AuthFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error: ${state.message}"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.blue),
                    );
                  }
                  return ElevatedButton(
                    onPressed: () {
                      if (isLoginMode) {
                        final email = _emailController.text.trim();
                        final password = _passwordController.text.trim();
                        context.read<AuthBloc>().add(
                          LoginEvent(email: email, password: password),
                        );
                      } else {
                        if (!isCheckboxChecked) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Harap setujui Syarat & Ketentuan terlebih dahulu",
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        final firstName = _firstNameController.text.trim();
                        final lastName = _lastNameController.text.trim();
                        final email = _emailController.text.trim();
                        final password = _passwordController.text.trim();

                        if (firstName.isEmpty ||
                            lastName.isEmpty ||
                            email.isEmpty ||
                            password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Semua field harus diisi"),
                            ),
                          );
                          return;
                        }

                        context.read<AuthBloc>().add(
                          RegisterEvent(
                            email: email,
                            password: password,
                            firstName: firstName,
                            lastName: lastName,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9747FF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      isLoginMode ? 'Masuk' : 'Daftar',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
              if (isLoginMode)
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Belum punya akun? ",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isLoginMode = false;
                            _emailController.clear();
                            _passwordController.clear();
                          });
                        },
                        child: Text(
                          "Daftar Sekarang",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: const Color(0xFF9747FF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData prefixIcon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    bool hasVisibilityToggle = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(color: Colors.grey.shade700),
          prefixIcon: Icon(prefixIcon, color: Colors.grey.shade700),
          suffixIcon:
              hasVisibilityToggle
                  ? IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey.shade700,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  )
                  : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        style: GoogleFonts.poppins(color: Colors.black),
        obscureText: obscureText,
        keyboardType: keyboardType,
      ),
    );
  }
}
