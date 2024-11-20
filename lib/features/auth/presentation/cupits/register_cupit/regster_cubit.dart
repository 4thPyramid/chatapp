import 'package:bloc/bloc.dart';
import 'package:chatapp/features/auth/data/domain/repos/auth_repo/auth_repo.dart';
import 'package:meta/meta.dart';


part 'regster_state.dart';


class RegsterCubit extends Cubit<RegsterState> {
  final AuthRepo authRepo;

  RegsterCubit({required this.authRepo}) : super(RegsterInitial());

  Future<void> registerWithEmailAndPassword(String email, String password, String name) async {
    emit(RegsterLoading());

    final result = await authRepo.createUserWithEmailAndPassword(email, password, name);

    result.fold(
      (failure) {
        emit(RegsterFailure(error: failure.message));
      },
      (userIntity) {
        emit(RegsterSuccess(message: 'Registration successful!'));
      },
    );
  }
}


