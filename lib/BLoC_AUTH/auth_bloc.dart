import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vilavi/BLoC_AUTH/auth_event.dart';
import 'package:vilavi/BLoC_AUTH/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthState()) {
    on<LoginEvent>((event, emit) {
      if (event.username == 'test' && event.password == 'password123') {
        emit(AuthState(isAuthenticated: true));
      } else {
        emit(AuthState(errorMessage: 'Неверный логин или пароль'));
      }
    });
  }
}