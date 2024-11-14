import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatapp/pages/data/domain/entites/user_intity.dart';
import 'package:dartz/dartz.dart';
import 'package:chatapp/core/errors/failures.dart';
import 'package:chatapp/pages/data/domain/repos/auth_repo/auth_repo.dart';
import 'package:chatapp/core/services/firebase_auth_service.dart';

class AuthRepoImpl implements AuthRepo {
  final FirebaseAuthService firebaseAuthService;
  final FirebaseFirestore firestore;

  AuthRepoImpl({required this.firebaseAuthService, required this.firestore});

  // تنفيذ دالة إنشاء مستخدم جديد
  @override
  Future<Either<Failure, UserIntity>> createUserWithEmailAndPassword(String email, String password, String name) async {
    try {
      final user = await firebaseAuthService.createUserWithEmailAndPassword(email, password);
      if (user != null) {
        // تحويل User إلى UserIntity
        final userIntity = UserIntity(email: user.email!, uid: user.uid);

        // حفظ بيانات المستخدم في Firestore
        await firestore.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
          'uid': user.uid,
        });

        return Right(userIntity);  // نجاح
      } else {
        return Left(Failure('User creation failed'));
      }
    } catch (e) {
      return Left(Failure(e.toString()));  // التعامل مع أي استثناء
    }
  }

  // تنفيذ دالة تسجيل الدخول
  @override
  Future<Either<Failure, UserIntity>> loginWithEmailAndPassword(String email, String password) async {
    try {
      final user = await firebaseAuthService.signInWithEmailAndPassword(email, password);
      if (user != null) {
        // تحويل User إلى UserIntity
        final userIntity = UserIntity(email: user.email!, uid: user.uid);
        return Right(userIntity);  // نجاح
      } else {
        return Left(Failure('Login failed'));
      }
    } catch (e) {
      return Left(Failure(e.toString()));  // التعامل مع أي استثناء
    }
  }
}
