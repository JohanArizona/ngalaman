import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
              SizedBox(height: 80),
              Image.asset(
                'lib/assets/Vector.png',
                width: 100,
                height: 100,
              ),
              SizedBox(height: 10),
              Text(
                'Selamat Datang',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Silahkan pilih mode: Login atau Register',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(height: 30),
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
                        backgroundColor: isLoginMode? Color(int.parse('0xFFD3D3D3')) : Color(int.parse('0xFF9747FF')),
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Daftar'),
                    ),
                  ),
                  SizedBox(width: 10),
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
                        backgroundColor: isLoginMode? Color(int.parse('0xFF9747FF')) : Color(int.parse('0xFFD3D3D3')),
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Masuk'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
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
                    SizedBox(width: 10),
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
              SizedBox(height: 20),
              // Input Email
              _buildTextField(
                controller: _emailController,
                label: 'Email atau Nomor Telepon',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.text,
                hasVisibilityToggle: false,
              ),
              SizedBox(height: 20),
              // Input Password
              _buildTextField(
                controller: _passwordController,
                label: 'Kata Sandi',
                prefixIcon: Icons.lock_outline,
                obscureText:!_isPasswordVisible,
                hasVisibilityToggle: true,
              ),
              if (!isLoginMode)
                SizedBox(height: 10),
              if (!isLoginMode)
                Row(
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
                      child: Text(
                        'Dengan melanjutkan ini, Anda menyetujui terhadap Syarat & Ketentuan Penggunaan dan Kebijakan Privasi',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 30),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Berhasil! Login atau Register berhasil"),
                        backgroundColor: Colors.green,
                      ),
                    );
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
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                      ),
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
                        final firstName = _firstNameController.text.trim();
                        final lastName = _lastNameController.text.trim();
                        final email = _emailController.text.trim();
                        final password = _passwordController.text.trim();

                        if (firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Semua field harus diisi")),
                          );
                          return;
                        }

                        context.read<AuthBloc>().add(
                              RegisterEvent(email: email, password: password),
                            );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(int.parse('0xFF9747FF')),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      isLoginMode? 'Masuk' : 'Daftar',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
              if (isLoginMode)
                Row(
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
                          color: Color(int.parse('0xFF9747FF')),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
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
          suffixIcon: hasVisibilityToggle
             ? IconButton(
                  icon: Icon(
                    !_isPasswordVisible? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey.shade700,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible =!_isPasswordVisible;
                    });
                  },
                )
             : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
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