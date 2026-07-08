class Dossier {
  final int id;
  final String numero;
  final int contrat;
  final int adhesion;
  final String nom;
  final String prenom;
  final String? adresse;
  final String? emploi;
  final String malade;
  final String dateNaissance;

  Dossier({
    required this.id,
    required this.numero,
    required this.contrat,
    required this.adhesion,
    required this.nom,
    required this.prenom,
    this.adresse,
    this.emploi,
    required this.malade,
    required this.dateNaissance,
  });

  factory Dossier.fromJson(Map<String, dynamic> json) {
    return Dossier(
      id: json['id'],
      numero: json['numero'],
      contrat: json['contrat'],
      adhesion: json['adhesion'],
      nom: json['nom'],
      prenom: json['prenom'],
      adresse: json['adresse'],
      emploi: json['emploi'],
      malade: json['malade'],
      dateNaissance: json['dateNaissance'],
    );
  }

  String get fullName => '$prenom $nom';
}