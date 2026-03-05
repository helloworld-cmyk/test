import 'package:flutter_bloc/flutter_bloc.dart';
import 'event.dart';
import 'state.dart';
import '../../../assets/BE.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState>{
  LoginBloc(): super(LoginState()){
    on<EmailChanged>((event, emit) {
      final String email = event.email;
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        emit(state.copyWith(
          email: email,
          emailError: 'Email không hợp lệ',
          showValidationErrors: true,
        ));
      } else {
        emit(state.copyWith(
          email: email,
          emailError: '',
          showValidationErrors: false,
        ));
      }
      emit(state.copyWith(email: event.email));
    });

    on<PasswordChanged>((event, emit) {
      final String password = event.password;
      if (password.length < 6) {
        emit(state.copyWith(
          password: password,
          passwordError: 'Mật khẩu phải có ít nhất 6 ký tự',
          showValidationErrors: true,
        ));
      } else {
        emit(state.copyWith(
          password: password,
          passwordError: '',
          showValidationErrors: false,
        ));
      }
      emit(state.copyWith(password: event.password));
    });

    on<ToggleShowPassword>((event, emit) {
      emit(state.copyWith(isShowPassword: !state.isShowPassword));
    });

    on<SubmitLogin>((event, emit) async {
      try {
        if (state.email.isEmpty || state.password.isEmpty) {
          emit(state.copyWith(
            showValidationErrors: true,
            emailError: state.email.isEmpty ? 'Email không được để trống' : '',
            passwordError: state.password.isEmpty ? 'Mật khẩu không được để trống' : '',
          ));
          return;
        }
        else if (state.emailError.isNotEmpty || state.passwordError.isNotEmpty) {
          emit(state.copyWith(showValidationErrors: true));
          return;
        }
        emit(state.copyWith(status: LoginStatus.loading));

        final result = await FakeAuthApi.instance.login(
          email: state.email.trim(),
          password: state.password,
        );


        if (result.success) {
          emit(state.copyWith(
            status: LoginStatus.success,
            fullName: result.user?['fullName'],
            userEmail: result.user?['email'],
          ));
        } else {
          emit(state.copyWith(
            status: LoginStatus.failure,
            errorMessage: result.message,
          ));
        }
      } catch (e) {
        emit(state.copyWith(
          status: LoginStatus.failure,
          errorMessage: 'Đã xảy ra lỗi khi đăng nhập',
        ));
      }
    });
  }

}