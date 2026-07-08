enum UserRole { admin, adherent }

class User {
  final String username;
  final UserRole role;
  final String? numDossier;

  User({required this.username, required this.role, this.numDossier});

  bool get isAdmin => role == UserRole.admin;
  bool get isAdherent => role == UserRole.adherent;
}