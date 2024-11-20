import 'package:chatapp/features/auth/presentation/cupits/login_cupit/login_state.dart';
import 'package:chatapp/features/auth/data/domain/repos/auth_repo/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
 

class LoginCubit extends Cubit<LoginState> {
  final AuthRepo authRepo;

  LoginCubit(this.authRepo) : super(LoginInitial());

  // دالة تسجيل الدخول
  Future<void> loginWithEmailAndPassword(String email, String password) async {
    emit(LoginLoading());  // وضع الـ state في حالة تحميل

    final result = await authRepo.loginWithEmailAndPassword(email, password);

    result.fold(
      (failure) {
        emit(LoginFailure(message: failure.message));  // في حالة الفشل
      },
      (userEntity) {
        emit(LoginSuccess(userEntity: userEntity));  // في حالة النجاح
      },
    );
  }

  // دالة إنشاء مستخدم جديد
  
}
