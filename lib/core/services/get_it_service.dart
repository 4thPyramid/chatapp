import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatapp/core/services/firebase_auth_service.dart';
import 'package:chatapp/features/auth/data/domain/repos/auth_repo/auth_repo.dart';
import 'package:chatapp/features/auth/data/domain/repos/auth_repo/auth_repo_impl.dart';
import 'package:get_it/get_it.dart';
import 'package:chatapp/features/auth/presentation/cupits/register_cupit/regster_cubit.dart';
import 'package:chatapp/features/auth/presentation/cupits/login_cupit/login_cubit.dart';
import 'package:chatapp/core/services/chat_service.dart';
import 'package:chatapp/features/chat/data/caht_repo/caht_repo.dart';
import 'package:chatapp/features/chat/data/caht_repo/chat_repo_impl.dart';
import 'package:chatapp/features/chat/presentation/cubit/chat_cupit_cubit.dart';

final getIt = GetIt.instance;

void setup() {
  // قم بتسجيل FirebaseAuthService
  getIt.registerLazySingleton<FirebaseAuthService>(() => FirebaseAuthService());
  
  // قم بتسجيل Firestore
  getIt.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // قم بتسجيل ChatService
  getIt.registerLazySingleton<ChatService>(() => ChatService());
  
  // قم بتسجيل ChatRepo
  getIt.registerLazySingleton<ChatRepo>(() => ChatRepoImpl(chatService: getIt<ChatService>()));
  
  // قم بتسجيل ChatCubit
  getIt.registerFactory<ChatCubit>(() => ChatCubit(chatRepo: getIt<ChatRepo>()));

  // قم بتسجيل AuthRepoImpl باستخدام FirebaseAuthService و FirebaseFirestore
  getIt.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(firebaseAuthService: getIt<FirebaseAuthService>(), firestore: getIt<FirebaseFirestore>()));

  // قم بتسجيل RegsterCubit باستخدام AuthRepo
  getIt.registerFactory<RegsterCubit>(() => RegsterCubit(authRepo: getIt<AuthRepo>()));

  // قم بتسجيل LoginCubit
  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt<AuthRepo>()));
}
