part of 'regster_cubit.dart';

@immutable
abstract class RegsterState {}

class RegsterInitial extends RegsterState {}

class RegsterLoading extends RegsterState {}

class RegsterSuccess extends RegsterState {
  final String message;  // يمكننا إرجاع رسالة عند نجاح التسجيل (مثلاً: "تم التسجيل بنجاح")
  RegsterSuccess({required this.message});
}

class RegsterFailure extends RegsterState {
  final String error;  // رسالة الخطأ في حالة الفشل
  RegsterFailure({required this.error});
}
