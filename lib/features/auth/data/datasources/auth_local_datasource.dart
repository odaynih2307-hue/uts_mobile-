import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel userToCache);
  Future<UserModel?> getCachedUser();
  Future<void> clearCachedUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const CACHED_USER = 'CACHED_USER';

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheUser(UserModel userToCache) async {
    await sharedPreferences.setString(
      CACHED_USER,
      json.encode(userToCache.toJson()),
    );
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final jsonString = sharedPreferences.getString(CACHED_USER);
    if (jsonString != null) {
      return UserModel.fromJson(json.decode(jsonString));
    }
    return null;
  }

  @override
  Future<void> clearCachedUser() async {
    await sharedPreferences.remove(CACHED_USER);
  }
}
