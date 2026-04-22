import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String username, String password);
  Future<UserModel> register(String username, String password, String name);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  // Mock Implementation for Fake Backend
  @override
  Future<UserModel> login(String username, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    if (username == 'admin' && password == 'admin123') {
      return const UserModel(
          id: '1', name: 'Super Admin', username: 'admin', role: 'admin');
    } else if (username == 'user' && password == 'user123') {
      return const UserModel(
          id: '2', name: 'Ody Dzakwan', username: 'user', role: 'user');
    } else {
      throw Exception('Username atau Password yang anda masukan salah');
    }
  }

  @override
  Future<UserModel> register(
      String username, String password, String name) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    if (username.isEmpty || password.isEmpty || name.isEmpty) {
      throw Exception('Validasi Gagal: Semua form harus diisi');
    }
    
    // Simulate successful registration returning a generic user model
    return UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      username: username,
      role: 'user',
    );
  }
}
