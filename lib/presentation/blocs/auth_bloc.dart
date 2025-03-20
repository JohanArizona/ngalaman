import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/forgot_password_usecase.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// LOGIN EVENT
class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

// REGISTER EVENT (Tambahkan firstName & lastName)
class RegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  RegisterEvent({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  @override
  List<Object?> get props => [email, password, firstName, lastName];
}

// FORGOT PASSWORD EVENT
class ForgotPasswordEvent extends AuthEvent {
  final String email;

  ForgotPasswordEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

// STATE MANAGEMENT
class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthPasswordResetSuccess extends AuthState {}

class AuthSuccess extends AuthState {
  final String userId;

  AuthSuccess({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class AuthFailure extends AuthState {
  final String message;

  AuthFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

// AUTH BLOC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.forgotPasswordUseCase,
  }) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<ForgotPasswordEvent>(_onForgotPassword);
  }

  void _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await loginUseCase.execute(event.email, event.password);
      if (user != null) {
        emit(AuthSuccess(userId: user.uid));
      } else {
        emit(AuthFailure(message: "Login gagal, coba lagi."));
      }
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  // REGISTER (Gunakan firstName dan lastName)
  void _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await registerUseCase.execute(
        event.email,
        event.password,
        event.firstName,
        event.lastName,
      );

      if (user != null) {
        emit(AuthSuccess(userId: user.uid));
      } else {
        emit(AuthFailure(message: "Registrasi gagal, coba lagi."));
      }
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  void _onForgotPassword(
    ForgotPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await forgotPasswordUseCase.execute(event.email);
      emit(AuthPasswordResetSuccess());
    } catch (e) {
      emit(AuthFailure(message: "Gagal mengirim email reset password"));
    }
  }
}
