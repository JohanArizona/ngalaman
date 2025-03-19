import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/forgot_password_usecase.dart'; // Import RegisterUseCase

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class RegisterEvent extends AuthEvent {
  final String email;
  final String password;

  RegisterEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

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

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase; // Tambahkan RegisterUseCase

  AuthBloc({required this.forgotPasswordUseCase, required this.loginUseCase, required this.registerUseCase})
      : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<ForgotPasswordEvent>(_onForgotPassword); // Tambahkan handler untuk RegisterEvent
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

  void _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await registerUseCase.execute(event.email, event.password);
      if (user != null) {
        emit(AuthSuccess(userId: user.uid));
      } else {
        emit(AuthFailure(message: "Registrasi gagal, coba lagi."));
      }
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  void _onForgotPassword(ForgotPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await forgotPasswordUseCase.execute(event.email);
      emit(AuthPasswordResetSuccess());
    } catch (e) {
      emit(AuthFailure(message: "Gagal mengirim email reset password"));
    }
  }
}

// Lupa Password
class ForgotPasswordEvent extends AuthEvent {
  final String email;
  ForgotPasswordEvent({required this.email});
}
