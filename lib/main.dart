import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ngalaman/domain/usecases/forgot_password_usecase.dart';
import 'package:ngalaman/presentation/pages/forgot_password_page.dart';
import 'package:ngalaman/presentation/pages/register_page.dart';
import 'package:ngalaman/presentation/pages/splash_screen.dart';
import 'data/datasources/auth_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/usecases/login_usecase.dart';
import 'domain/usecases/register_usecase.dart';
import 'presentation/blocs/auth_bloc.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final authDataSource = AuthDataSourceImpl(auth: FirebaseAuth.instance);
  final authRepository = AuthRepositoryImpl(authDataSource: authDataSource);
  final loginUseCase = LoginUseCase(repository: authRepository);
  final registerUseCase = RegisterUseCase(repository: authRepository);
  final forgotPasswordUseCase = ForgotPasswordUseCase(
    repository: authRepository,
  );

  runApp(
    MyApp(
      loginUseCase: loginUseCase,
      registerUseCase: registerUseCase,
      forgotPasswordUseCase: forgotPasswordUseCase,
    ),
  );
}

class MyApp extends StatelessWidget {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;

  const MyApp({
    super.key,
    required this.loginUseCase,
    required this.registerUseCase,
    required this.forgotPasswordUseCase,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create:
              (context) => AuthBloc(
                loginUseCase: loginUseCase,
                registerUseCase: registerUseCase,
                forgotPasswordUseCase: forgotPasswordUseCase,
              ),
        ),
      ],
      child: MaterialApp(
        title: 'Ngalaman',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Poppins',
        ),
        home: const SplashScreen(),
        routes: {
          '/register': (context) => const RegisterPage(),
          '/forgot-password': (context) => ForgotPasswordPage(),
        },
      ),
    );
  }
}
