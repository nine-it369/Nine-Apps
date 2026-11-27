import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final IAuthRemoteDataSource remoteDataSource;
  final IAuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, UserEntity>> login({
    required String phone,
    required String password,
  }) async {
    try {
      final loginData = await remoteDataSource.login(
        phone: phone,
        password: password,
      );
      final token = loginData['token'] as String? ?? '';
      if (token.isNotEmpty) {
        await localDataSource.saveToken(token);
      }

      // Fetch user profile from remote
      try {
        final user = await remoteDataSource.getCurrentUser();
        await localDataSource.saveCachedUser(user);
        return Either.right(user);
      } catch (_) {
        final fallbackUser = UserModel(
          id: (loginData['customer_id'] as num?)?.toInt() ?? 1,
          name: 'Pelanggan Nine',
          phone: phone,
          referralCode: 'NINE-VIP',
          nineKoinBalance: 0,
          isActive: true,
          isVerified: true,
        );
        await localDataSource.saveCachedUser(fallbackUser);
        return Either.right(fallbackUser);
      }
    } catch (e) {
      if (e is ServerException) {
        return Either.left(ServerFailure(e.message, e.statusCode));
      }
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register({
    required String name,
    required String phone,
    required String password,
  }) async {
    try {
      final regData = await remoteDataSource.register(
        name: name,
        phone: phone,
        password: password,
      );
      final token = regData['token'] as String? ?? '';
      if (token.isNotEmpty) {
        await localDataSource.saveToken(token);
      }

      final user = UserModel(
        id: (regData['customer_id'] as num?)?.toInt() ?? 1,
        name: name,
        phone: phone,
        referralCode: regData['referral_code'] as String? ?? 'NINE-VIP',
        nineKoinBalance: 0,
        isActive: true,
        isVerified: true,
      );
      await localDataSource.saveCachedUser(user);
      return Either.right(user);
    } catch (e) {
      if (e is ServerException) {
        return Either.left(ServerFailure(e.message, e.statusCode));
      }
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final token = localDataSource.getToken();
      if (token != null && token.isNotEmpty) {
        final remoteUser = await remoteDataSource.getCurrentUser();
        await localDataSource.saveCachedUser(remoteUser);
        return Either.right(remoteUser);
      }
      final cached = localDataSource.getCachedUser();
      return Either.right(cached);
    } catch (e) {
      final cached = localDataSource.getCachedUser();
      if (cached != null) {
        return Either.right(cached);
      }
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearSession();
      return Either.right(null);
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }
}
