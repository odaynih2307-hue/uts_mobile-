import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String username, String password);
  Future<Either<Failure, User>> register(String username, String password, String name);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, User>> checkAuthStatus();
}
