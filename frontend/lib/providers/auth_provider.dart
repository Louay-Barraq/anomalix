import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthNotifier extends Notifier<User?> {
  @override
  User? build() => null;

  Future<bool> login(String username, String password) async {
    try {
      final response = await ApiService().login(username, password);

      if (response['success'] == true) {
        final allRoles = List<String>.from(response['allRoles'] ?? []);
        final role = response['role'] == 'ADMIN'
            ? UserRole.admin
            : UserRole.adherent;

        state = User(
          username: username,
          role: role,
          token: response['token'],
          numDossier: response['numDossier'],
          allRoles: allRoles,
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

  Future<bool> switchRole(String targetRole) async {
    try {
      final currentUser = state;
      if (currentUser == null) return false;

      final response = await ApiService(
        token: currentUser.token,
      ).switchRole(targetRole);

      if (response['success'] == true) {
        final role = response['role'] == 'ADMIN'
            ? UserRole.admin
            : UserRole.adherent;

        final newToken = response['token'] as String;
        debugPrint(
          'Role switch succeeded for ${currentUser.username} -> $targetRole, new token: $newToken',
        );

        state = User(
          username: currentUser.username,
          role: role,
          token: newToken,
          numDossier: currentUser.numDossier,
          allRoles: currentUser.allRoles,
        );
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  void logout() => state = null;
}

final authProvider = NotifierProvider<AuthNotifier, User?>(() {
  return AuthNotifier();
});
