// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:raion_intern_16/presentation/pages/register_page.dart';
// import '../blocs/auth_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _isPasswordVisible = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               SizedBox(height: 20),
//               // Menambahkan logo, pastikan asset telah ditambahkan ke pubspec.yaml
//               Image.asset(
//                 'lib/assets/Vector.png', // Ganti dengan nama file logo sebenarnya
//                 width: 100,
//                 height: 100,
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Selamat Datang',
//                 textAlign: TextAlign.center,
//                 style: GoogleFonts.poppins(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Silahkan masuk ke akun Anda',
//                 textAlign: TextAlign.center,
//                 style: GoogleFonts.poppins(
//                   fontSize: 16,
//                   color: Colors.grey.shade700,
//                 ),
//               ),
//               SizedBox(height: 30),
//               // Input Email
//               _buildTextField(
//                 controller: _emailController,
//                 label: 'Email atau Nomor Telepon',
//                 prefixIcon: Icons.email_outlined,
//                 keyboardType: TextInputType.text,
//               ),
//               SizedBox(height: 20),
//               // Input Password
//               _buildTextField(
//                 controller: _passwordController,
//                 label: 'Kata Sandi',
//                 prefixIcon: Icons.lock_outline,
//                 obscureText:!_isPasswordVisible,
//                 hasVisibilityToggle: true,
//               ),
//               SizedBox(height: 20),
//               BlocConsumer<AuthBloc, AuthState>(
//                 listener: (context, state) {
//                   if (state is AuthSuccess) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text("Berhasil! Login berhasil"),
//                         backgroundColor: Colors.green,
//                       ),
//                     );
//                   } else if (state is AuthFailure) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text("Error: ${state.message}"),
//                         backgroundColor: Colors.red,
//                       ),
//                     );
//                   }
//                 },
//                 builder: (context, state) {
//                   if (state is AuthLoading) {
//                     return Center(
//                       child: CircularProgressIndicator(
//                         color: Colors.blue,
//                       ),
//                     );
//                   }
//                   return ElevatedButton(
//                     onPressed: () {
//                       final email = _emailController.text.trim();
//                       final password = _passwordController.text.trim();
//                       context.read<AuthBloc>().add(
//                             LoginEvent(email: email, password: password),
//                           );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Color(int.parse('0xFF9747FF')),
//                       foregroundColor: Colors.white,
//                       padding: EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     child: Text(
//                       'Masuk',
//                       style: GoogleFonts.poppins(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Belum punya akun? ",
//                     style: GoogleFonts.poppins(
//                       fontSize: 16,
//                       color: Colors.grey.shade700,
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const RegisterPage(),
//                         ),
//                       );
//                     },
//                     child: Text(
//                       "Daftar Sekarang",
//                       style: GoogleFonts.poppins(
//                         fontSize: 16,
//                         color: Color(int.parse('0xFF9747FF')),
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData prefixIcon,
//     bool obscureText = false,
//     TextInputType keyboardType = TextInputType.text,
//     bool hasVisibilityToggle = false,
//   }) {
//     bool _isObscure = obscureText;
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.grey.shade200,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: TextField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           labelStyle: GoogleFonts.poppins(color: Colors.grey.shade700),
//           prefixIcon: Icon(prefixIcon, color: Colors.grey.shade700),
//           suffixIcon: hasVisibilityToggle
//              ? IconButton(
//                   icon: Icon(
//                     _isObscure? Icons.visibility_off : Icons.visibility,
//                     color: Colors.grey.shade700,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       _isObscure =!_isObscure;
//                     });
//                   },
//                 )
//              : null,
//           border: InputBorder.none,
//           contentPadding: EdgeInsets.symmetric(
//             horizontal: 20,
//             vertical: 16,
//           ),
//         ),
//         style: GoogleFonts.poppins(color: Colors.black),
//         obscureText: _isObscure,
//         keyboardType: keyboardType,
//       ),
//     );
//   }
// }