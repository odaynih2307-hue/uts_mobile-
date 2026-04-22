import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, User>> login(String username, String password) async {
    try {
      final userModel = await remoteDataSource.login(username, password);
      // Cache token/user data on success
      await localDataSource.cacheUser(userModel);
      return Right(userModel);
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, User>> register(String username, String password, String name) async {
    try {
      final userModel = await remoteDataSource.register(username, password, name);
      // Automatically login after successful register, or not, depending on requirement.
      // We will assume auto-login here.
      await localDataSource.cacheUser(userModel);
      return Right(userModel);
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearCachedUser();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure("Failed to logout"));
    }
  }

  @override
  Future<Either<Failure, User>> checkAuthStatus() async {
    try {
      final userModel = await localDataSource.getCachedUser();
      if (userModel != null) {
        return Right(userModel);
      } else {
        return const Left(CacheFailure("No user cached"));
      }
    } catch (e) {
      return Left(CacheFailure("Error decoding cache"));
    }
  }
}
