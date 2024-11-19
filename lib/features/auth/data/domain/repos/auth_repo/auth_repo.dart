import 'package:chatapp/core/errors/failures.dart';
import 'package:chatapp/pages/data/domain/entites/user_intity.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepo {
Future<Either<Failure, UserIntity>> createUserWithEmailAndPassword(String email, String password,String name);
  Future<Either<Failure, UserIntity>> loginWithEmailAndPassword(String email, String password);
}
