import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import 'package:dio/dio.dart';

class AuthNotifier extends Notifier<User?> {
  @override
  User? build() => null;

  Future<bool> login(String username, String password) async {
    try {
      final response = await ApiService().login(username, password);
      if (response['success'] == true) {
        final role = response['role'] == 'admin'
            ? UserRole.admin
            : UserRole.adherent;
        state = User(
          username: username,
          role: role,
          numDossier: response['numDossier'],
        );
        return true;
      }
      return false;
    } on DioException catch (e) {
      final error = ApiService.extractError(e);
      throw ApiException(message: error.message);
    } catch (e) {
      return false;
    }
  }

  void logout() => state = null;
}

final authProvider = NotifierProvider<AuthNotifier, User?>(() {
  return AuthNotifier();
});