enum UserRole { admin, adherent }

class User {
  final String username;
  final UserRole role;
  final String? numDossier;
  final List<String> allRoles;
  final String token;

  User({
    required this.username,
    required this.role,
    required this.token,
    this.numDossier,
    this.allRoles = const [],
  });

  bool get isAdmin => role == UserRole.admin;
  bool get isAdherent => role == UserRole.adherent;
  bool get hasMultipleRoles => allRoles.length > 1;
}